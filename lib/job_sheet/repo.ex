defmodule JobSheet.Repo do
  use Ecto.Repo,
    otp_app: :job_sheet,
    adapter: Ecto.Adapters.Postgres
end
