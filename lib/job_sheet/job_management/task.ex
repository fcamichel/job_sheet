defmodule JobSheet.JobManagement.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "tasks" do
    field :title, :string
    field :description, :string
    field :completed, :boolean, default: false
    field :completed_at, :utc_datetime

    belongs_to :category, JobSheet.JobManagement.Category
    belongs_to :institution, JobSheet.JobManagement.Institution
    belongs_to :user, JobSheet.Accounts.User
    has_many :history_entries, JobSheet.JobManagement.TaskHistory

    timestamps(type: :utc_datetime)
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [
      :title,
      :description,
      :completed,
      :completed_at,
      :category_id,
      :institution_id,
      :user_id
    ])
    |> validate_required([:title, :category_id, :institution_id, :user_id])
    |> validate_length(:title, min: 1, max: 255)
    |> maybe_set_completed_at()
  end

  defp maybe_set_completed_at(changeset) do
    case get_change(changeset, :completed) do
      true ->
        put_change(changeset, :completed_at, DateTime.utc_now() |> DateTime.truncate(:second))

      false ->
        put_change(changeset, :completed_at, nil)

      _ ->
        changeset
    end
  end
end
