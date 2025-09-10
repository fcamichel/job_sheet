defmodule JobSheet.JobManagement.TaskHistory do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "task_histories" do
    field :action, :string
    field :changes, :map
    field :performed_at, :utc_datetime

    belongs_to :task, JobSheet.JobManagement.Task
    belongs_to :user, JobSheet.Accounts.User

    timestamps(type: :utc_datetime, updated_at: false)
  end

  def changeset(task_history, attrs) do
    task_history
    |> cast(attrs, [:action, :changes, :performed_at, :task_id, :user_id])
    |> validate_required([:action, :performed_at, :task_id, :user_id])
    |> validate_inclusion(:action, ["created", "updated", "completed", "uncompleted", "deleted"])
  end
end
