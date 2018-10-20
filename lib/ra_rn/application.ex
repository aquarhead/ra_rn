defmodule RaRn.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    topologies = Application.get_env(:ra_rn, :libcluster)

    children = [
      {Cluster.Supervisor, [topologies, [name: RaRn.ClusterSup]]}
    ]

    opts = [strategy: :one_for_one, name: RaRn.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
