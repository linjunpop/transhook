# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :transhook,
  ecto_repos: [Transhook.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :transhook, TranshookWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TpwKIIHShZ3h8n0VZRZ+ym8YegJ5v3CQwtgOciUXNKaMnfRrtMsYPEu585AOcUwK",
  render_errors: [view: TranshookWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Transhook.PubSub,
  live_view: [signing_salt: "gU2K1qb0"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
