defmodule RaRn.MixProject do
  use Mix.Project

  def project do
    [
      app: :ra_rn,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :sasl],
      mod: {RaRn.Application, []}
    ]
  end

  defp deps do
    [
      {:ra, github: "rabbitmq/ra"},

      # http requests
      {:hackney, "~> 1.14"},
      {:tesla, "~> 1.1"},
      {:jason, "~> 1.1"},

      # clustering
      {:libcluster, "~> 3.0"}
    ]
  end
end
