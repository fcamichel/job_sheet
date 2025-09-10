defmodule JobSheet.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      JobSheetWeb.Telemetry,
      JobSheet.Repo,
      {DNSCluster, query: Application.get_env(:job_sheet, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: JobSheet.PubSub},
      {Finch, name: JobSheet.Finch},
      JobSheetWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: JobSheet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    JobSheetWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
