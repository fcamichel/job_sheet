import Config

config :job_sheet,
  ecto_repos: [JobSheet.Repo],
  generators: [timestamp_type: :utc_datetime]

config :job_sheet, JobSheetWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: JobSheetWeb.ErrorHTML, json: JobSheetWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: JobSheet.PubSub,
  live_view: [signing_salt: "hL7JM5Kx"]

config :job_sheet, JobSheet.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.3.0",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :guardian, JobSheet.Guardian,
  issuer: "job_sheet",
  secret_key: "your-secret-key-change-in-production"

import_config "#{config_env()}.exs"
