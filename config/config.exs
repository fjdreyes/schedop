# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :schedop,
  ecto_repos: [Schedop.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :schedop, SchedopWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: SchedopWeb.ErrorHTML, json: SchedopWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Schedop.PubSub,
  live_view: [signing_salt: "ccZYlGSz"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :schedop, Schedop.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.25.3",
  schedop: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.8",
  schedop: [
    args: ~w(
    --input=assets/css/app.css
    --output=priv/static/assets/app.css
  ),
    cd: Path.expand("..", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :schedop,
  openrouteservice_url:
    System.get_env("OPENROUTESERVICE_URL") ||
      "https://api.openrouteservice.org/v2/directions/foot-walking/geojson",
  openrouteservice_api_key: System.get_env("OPENROUTESERVICE_API_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
