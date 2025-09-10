defmodule JobSheet.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :description, :text
      add :completed, :boolean, default: false, null: false
      add :completed_at, :utc_datetime
      add :category_id, references(:categories, type: :binary_id, on_delete: :delete_all), null: false
      add :institution_id, references(:institutions, type: :binary_id, on_delete: :delete_all), null: false
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:category_id])
    create index(:tasks, [:institution_id])
    create index(:tasks, [:user_id])
    create index(:tasks, [:completed])
  end
end
