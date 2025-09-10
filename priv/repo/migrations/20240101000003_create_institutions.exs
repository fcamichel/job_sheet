defmodule JobSheet.Repo.Migrations.CreateInstitutions do
  use Ecto.Migration

  def change do
    create table(:institutions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :text
      add :contact_info, :text
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:institutions, [:name])
    create index(:institutions, [:user_id])
  end
end
