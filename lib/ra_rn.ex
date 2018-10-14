defmodule RaRn do
  @moduledoc false

  def track_repo(repo) do
    servers = [{:server1, node()}, {:server2, node()}, {:server3, node()}]
    cluster_id = repo
    machine = {:module, RaRn.Repo, %{repo: repo}}
    Application.ensure_all_started(:ra)
    :ra.start_cluster(cluster_id, machine, servers)
  end
end
