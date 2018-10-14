defmodule RaRn.ReleaseChecker do
  use GenServer
  alias RaRn.GraphClient

  defstruct [
    :owner,
    :name,
    :ra_server
  ]

  def start_link(owner, name, ra_server) do
    args = [owner: owner, name: name, ra_server: ra_server]
    GenServer.start_link(__MODULE__, args)
  end

  @impl true
  def init(owner: owner, name: name, ra_server: ra_server) do
    init_state = %__MODULE__{
      owner: owner,
      name: name,
      ra_server: ra_server
    }

    {:ok, init_state, {:continue, :query_latest}}
  end

  @impl true
  def handle_continue(:query_latest, state) do
    latest_release = GraphClient.query_latest_release(state.owner, state.name)
    :ra.process_command(state.ra_server, {:latest_release, latest_release})

    # Process.send_after(self(), :query_new, )

    {:noreply, state}
  end
end
