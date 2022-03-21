import Config

config :transhook,
  ecto_repos: [Transhook.Repo],
  generators: [binary_id: true]

config :transhook, :basic_auth,
  username: "admin",
  password: "secret"

# Configures the endpoint
config :transhook, TranshookWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TpwKIIHShZ3h8n0VZRZ+ym8YegJ5v3CQwtgOciUXNKaMnfRrtMsYPEu585AOcUwK",
  render_errors: [view: TranshookWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Transhook.PubSub,
  live_view: [signing_salt: "gU2K1qb0"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
