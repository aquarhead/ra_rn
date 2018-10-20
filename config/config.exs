use Mix.Config

config :logger,
  level: :warn,
  handle_otp_reports: true,
  handle_sasl_reports: true

config :ra_rn, :github_token, ""

config :ra_rn, :notifications, []

import_config "secret.exs"
