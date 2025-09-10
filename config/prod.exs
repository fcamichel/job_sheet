import Config

config :job_sheet, JobSheetWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info

config :job_sheet, JobSheet.Repo,
  ssl: true,
  ssl_opts: [verify: :verify_none]
