# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :simple_auth,
  ecto_repos: [SimpleAuth.Repo]

# Configures the endpoint
config :simple_auth, SimpleAuth.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9SbizyjDVcuiFzQSjHLCCpMWvqTe97pVuxDN/QmssGYRVVh7p2UmSKoG3HpygHI9",
  render_errors: [view: SimpleAuth.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SimpleAuth.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "SimpleAuth.#{Mix.env}",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: SimpleAuth.GuardianSerializer,
  secret_key: to_string(Mix.env) <> "SuPerseCret_aBraCadabrA"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
