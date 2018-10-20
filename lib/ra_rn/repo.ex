defmodule RaRn.Repo do
  @behaviour :ra_machine

  defstruct [
    :repo,
    :latest_release
  ]

  def add_new_releases(server, new_releases) do
    :ra.process_command(server, {:new_releases, new_releases})
  end

  def query_latest_release(server) do
    :ra.consistent_query(server, fn state -> state.latest_release end)
  end

  @impl true
  def init(%{repo: repo, latest_release: latest_release}) do
    %__MODULE__{
      repo: repo,
      latest_release: latest_release
    }
  end

  @impl true
  def overview(state) do
    %{latest_release_name: state.latest_release.tag}
  end

  @impl true
  def apply(_meta, {:new_releases, new_releases}, effects, state) do
    new_latest = Enum.at(new_releases, 0)
    new_state = %__MODULE__{state | latest_release: new_latest}

    notify_cmd = {:mod_call, RaRn.Notification, :notify_all, [state.repo, new_latest]}

    {new_state, [notify_cmd | effects], :ok}
  end
end
