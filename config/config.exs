# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :zaun_lookup, ecto_repos: [ZaunLookup.Repo]

# Configures the endpoint
config :zaun_lookup, ZaunLookupWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "n9M/JzyvB4oJFvzqrRn68c21yWB3ADYslOKWZlMfvGcurXPKSaWUYkSMwpLSfAfG",
  render_errors: [view: ZaunLookupWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ZaunLookup.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :zaun_lookup, ZaunLookup.Scheduler,
  jobs: [
    # Every minute
    {{:extended, "* * * * *"}, fn -> IO.puts("Hello Zaun") end}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
