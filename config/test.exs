use Mix.Config

# Configure your database
config :zaun_lookup, ZaunLookup.Repo,
  username: "postgres",
  password: "postgres",
  database: "zaun_lookup_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :zaun_lookup, ZaunLookupWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
