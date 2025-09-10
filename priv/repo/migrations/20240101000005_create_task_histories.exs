defmodule JobSheet.Repo.Migrations.CreateTaskHistories do
  use Ecto.Migration

  def change do
    create table(:task_histories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :action, :string, null: false
      add :changes, :map, default: %{}
      add :performed_at, :utc_datetime, null: false
      add :task_id, references(:tasks, type: :binary_id, on_delete: :delete_all), null: false
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:task_histories, [:task_id])
    create index(:task_histories, [:user_id])
    create index(:task_histories, [:performed_at])
  end
end
