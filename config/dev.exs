import Config

config :job_sheet, JobSheet.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "job_sheet_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :job_sheet, JobSheetWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "9XvKJH5L+FqNYYBh8xYNwBH1234567890abcdefghijklmnopqrstuvwxyz1234567890",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]

config :job_sheet, JobSheetWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/job_sheet_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :job_sheet, dev_routes: true

config :phoenix, :plug_init_mode, :runtime

config :phoenix, :stacktrace_depth, 20

config :logger, :console, format: "[$level] $message\n"
