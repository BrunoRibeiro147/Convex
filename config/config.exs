# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :convex,
  ecto_repos: [Core.Repo]

# Configures the endpoint
config :convex, WebAPI.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lrnlJ7w+gtydekzv1V+BZfH0gRStZDqxH1hZVTEpic8kW90/MJVIj8qcm3khnFHf",
  render_errors: [view: WebAPI.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Core.PubSub,
  live_view: [signing_salt: "1v+cnVfY"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Adapters

config :convex, Core.Ports.FetchConvertionTax,
  adapter: Core.Adapters.FetchConvertionTax.ExchangeRates

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
