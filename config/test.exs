import Config

config :job_sheet, JobSheet.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "job_sheet_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :job_sheet, JobSheetWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "test_secret_key_base_1234567890abcdefghijklmnopqrstuvwxyz1234567890",
  server: false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime
