defmodule RaRn do
  @moduledoc false

  def track_repo(repo) do
    [owner, name] = String.split(repo, "/")

    latest_release = RaRn.GraphClient.query_latest_release(owner, name)
    RaRn.Notification.notify_all(repo, latest_release)

    server_name = String.to_atom("ra_server_" <> repo)
    servers = Stream.repeatedly(fn -> server_name end) |> Enum.zip(:erlang.nodes())
    cluster_id = repo
    machine = {:module, RaRn.Repo, %{repo: repo, latest_release: latest_release}}

    {:ok, servers, _} = :ra.start_cluster(cluster_id, machine, servers)
    RaRn.ReleaseChecker.start_link(owner, name, Enum.random(servers))

    servers
  end
end
