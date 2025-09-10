defmodule JobSheet.JobManagement do
  import Ecto.Query, warn: false
  alias JobSheet.Repo
  alias JobSheet.JobManagement.{Category, Institution, Task, TaskHistory}

  # Categories
  def list_categories do
    Repo.all(Category)
  end

  def get_category!(id), do: Repo.get!(Category, id)

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  # Institutions
  def list_institutions do
    Repo.all(Institution)
  end

  def get_institution!(id), do: Repo.get!(Institution, id)

  def create_institution(attrs \\ %{}) do
    %Institution{}
    |> Institution.changeset(attrs)
    |> Repo.insert()
  end

  def update_institution(%Institution{} = institution, attrs) do
    institution
    |> Institution.changeset(attrs)
    |> Repo.update()
  end

  def delete_institution(%Institution{} = institution) do
    Repo.delete(institution)
  end

  def change_institution(%Institution{} = institution, attrs \\ %{}) do
    Institution.changeset(institution, attrs)
  end

  # Tasks
  def list_tasks do
    Repo.all(Task)
    |> Repo.preload([:category, :institution, :user])
  end

  def list_tasks_by_category(category_id) do
    Task
    |> where([t], t.category_id == ^category_id)
    |> Repo.all()
    |> Repo.preload([:category, :institution, :user])
  end

  def list_tasks_by_institution(institution_id) do
    Task
    |> where([t], t.institution_id == ^institution_id)
    |> Repo.all()
    |> Repo.preload([:category, :institution, :user])
  end

  def list_tasks_by_category_and_institution(category_id, institution_id) do
    Task
    |> where([t], t.category_id == ^category_id and t.institution_id == ^institution_id)
    |> Repo.all()
    |> Repo.preload([:category, :institution, :user])
  end

  def get_task!(id) do
    Repo.get!(Task, id)
    |> Repo.preload([:category, :institution, :user, :history_entries])
  end

  def create_task(attrs \\ %{}, user_id) do
    Repo.transaction(fn ->
      task_attrs = Map.put(attrs, "user_id", user_id)
      
      case %Task{}
           |> Task.changeset(task_attrs)
           |> Repo.insert() do
        {:ok, task} ->
          # Create history entry
          create_task_history(task.id, user_id, "created", %{})
          task
        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end

  def update_task(%Task{} = task, attrs, user_id) do
    Repo.transaction(fn ->
      # Track changes before update
      changes = track_changes(task, attrs)
      
      case task
           |> Task.changeset(attrs)
           |> Repo.update() do
        {:ok, updated_task} ->
          # Create history entry
          action = if Map.get(attrs, "completed") != task.completed do
            if Map.get(attrs, "completed"), do: "completed", else: "uncompleted"
          else
            "updated"
          end
          
          create_task_history(updated_task.id, user_id, action, changes)
          updated_task
        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end

  def delete_task(%Task{} = task, user_id) do
    Repo.transaction(fn ->
      # Create history entry before deletion
      create_task_history(task.id, user_id, "deleted", %{})
      
      case Repo.delete(task) do
        {:ok, task} -> task
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end

  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  def mark_task_completed(%Task{} = task, user_id) do
    update_task(task, %{"completed" => true}, user_id)
  end

  def mark_task_incomplete(%Task{} = task, user_id) do
    update_task(task, %{"completed" => false}, user_id)
  end

  def copy_task_to_category(%Task{} = task, category_id, user_id) do
    task_attrs = %{
      "title" => task.title,
      "description" => task.description,
      "category_id" => category_id,
      "institution_id" => task.institution_id,
      "completed" => false
    }
    
    create_task(task_attrs, user_id)
  end

  # Task History
  def list_task_history(task_id) do
    TaskHistory
    |> where([th], th.task_id == ^task_id)
    |> order_by([th], desc: th.performed_at)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  defp create_task_history(task_id, user_id, action, changes) do
    %TaskHistory{}
    |> TaskHistory.changeset(%{
      task_id: task_id,
      user_id: user_id,
      action: action,
      changes: changes,
      performed_at: DateTime.utc_now()
    })
    |> Repo.insert!()
  end

  defp track_changes(task, attrs) do
    attrs
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      old_value = Map.get(task, String.to_existing_atom(key))
      if old_value != value do
        Map.put(acc, key, %{"old" => old_value, "new" => value})
      else
        acc
      end
    end)
  end
end
