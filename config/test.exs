use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :desqer, Desqer.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :desqer, Desqer.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "desqer_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Reduce round numbers for test speed
config :comeonin, :bcrypt_log_rounds, 4
