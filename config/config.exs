# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :planning_poker,
  ecto_repos: [PlanningPoker.Repo],
  live_view_dashboard: [password:  ""]

# Configures the endpoint
config :planning_poker, PlanningPokerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hq3W9tOivQELKQV9JBGGFzq0PIcWY94kH+u9Gc51ciGBhdFuqoB9eFZ0YYQ+TWys",
  render_errors: [view: PlanningPokerWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: PlanningPoker.PubSub,
  live_view: [signing_salt: "Xq0sdPWuD1793to6c3OyXzRv6uVPOHNU"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
