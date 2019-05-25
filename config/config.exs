# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :zaun_lookup,
  ecto_repos: [ZaunLookup.Repo]

# Configures the endpoint
config :zaun_lookup, ZaunLookupWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "t4uB1zvI/FBDlVpvLgW1n5K6LqxFIBJfuhr2wXNl9WSbMklrYhTDzAawolPZcXDV",
  render_errors: [view: ZaunLookupWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ZaunLookup.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "DxeBhxEoL2OucYBaaLKTvzsK5gKAR5iC"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
