use Mix.Config

config :logger,
  level: :warn,
  handle_otp_reports: true,
  handle_sasl_reports: true

config :ra_rn, :github_token, ""

config :ra_rn, :notifications, []

config :ra_rn, :libcluster, [
  local: [
    strategy: Cluster.Strategy.Epmd,
    config: [hosts: [:"a@127.0.0.1", :"b@127.0.0.1", :"c@127.0.0.1"]]
  ]
]

import_config "secret.exs"
