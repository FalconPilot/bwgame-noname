# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :webccg,
  ecto_repos: [Webccg.Repo]

# Configures the endpoint
config :webccg, Webccg.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rebpJveVgD9SJKtEkj8Y1KTtr33m4sjuBqRa58Ksnw3Y4A3kDzjMxUSKwHcRu7zQ",
  render_errors: [view: Webccg.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Webccg.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
