defmodule JobSheet.JobManagement.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "categories" do
    field :name, :string
    field :description, :string

    has_many :tasks, JobSheet.JobManagement.Task
    belongs_to :user, JobSheet.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description, :user_id])
    |> validate_required([:name, :user_id])
    |> validate_length(:name, min: 1, max: 255)
    |> unique_constraint(:name)
  end
end
