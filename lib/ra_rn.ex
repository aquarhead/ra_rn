defmodule RaRn do
  @moduledoc false

  def track_repo(repo) do
    [owner, name] = String.split(repo, "/")

    latest_release = RaRn.GraphClient.query_latest_release(owner, name)
    RaRn.Notification.notify_all(repo, latest_release)

    servers = [{:server1, node()}, {:server2, node()}, {:server3, node()}]
    cluster_id = repo
    machine = {:module, RaRn.Repo, %{repo: repo, latest_release: latest_release}}
    Application.ensure_all_started(:ra)
    {:ok, servers, _} = :ra.start_cluster(cluster_id, machine, servers)

    RaRn.ReleaseChecker.start_link(owner, name, Enum.random(servers))

    servers
  end
end
