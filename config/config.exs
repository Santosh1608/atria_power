# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :atria_power,
  ecto_repos: [AtriaPower.Repo]

# Configures the endpoint
config :atria_power, AtriaPowerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "F6bEVjvp9oLJTB2Q5kfBpGvKvELqjdeKgTgS2vGWFgHTjBcsxIDq5G2LzL7G2oGZ",
  render_errors: [view: AtriaPowerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: AtriaPower.PubSub,
  live_view: [signing_salt: "MNWrGukM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
