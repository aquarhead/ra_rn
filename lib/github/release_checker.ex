defmodule RaRn.ReleaseChecker do
  use GenServer
  alias RaRn.GraphClient
  alias RaRn.Repo

  defstruct [
    :owner,
    :name,
    :ra_server,
    :interval
  ]

  def start_link(owner, name, ra_server) do
    args = [owner: owner, name: name, ra_server: ra_server]
    GenServer.start_link(__MODULE__, args)
  end

  @impl true
  def init(owner: owner, name: name, ra_server: ra_server) do
    interval = Application.get_env(:ra_rn, __MODULE__)[:interval]

    init_state = %__MODULE__{
      owner: owner,
      name: name,
      ra_server: ra_server,
      interval: interval
    }

    Process.send_after(self(), :query_new, interval)

    {:ok, init_state}
  end

  @impl true
  def handle_info(:query_new, state) do
    {:ok, latest_release, leader} = Repo.query_latest_release(state.ra_server)
    new_releases = GraphClient.query_new_releases(state.owner, state.name, latest_release.cursor)

    if length(new_releases) > 0 do
      Repo.add_new_releases(leader, new_releases)
    end

    Process.send_after(self(), :query_new, state.interval)

    {:noreply, %__MODULE__{state | ra_server: leader}}
  end
end
