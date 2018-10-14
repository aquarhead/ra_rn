defmodule RaRn.Repo do
  @behaviour :ra_machine

  defstruct [
    :cluster_id,
    :repo,
    :latest_release,
    :rc_pid,
    :ra_server_name
  ]

  @impl true
  def init(%{repo: repo, name: ra_server_name}) do
    # ensure valid repo string (should move to outer API later)
    [_owner, _name] = String.split(repo, "/")

    %__MODULE__{
      repo: repo,
      latest_release: nil,
      rc_pid: nil,
      ra_server_name: ra_server_name
    }
  end

  @impl true
  def state_enter(:leader, state) do
    # start ReleaseChecker when becoming a leader
    [owner, name] = String.split(state.repo, "/")
    # {:ok, pid} = .start_link() # TODO make into an effect list
    # [{:mod_call, RaRn.ReleaseChecker, :start_link, [owner, name, state.ra_server_name]}]
    []
  end

  def state_enter(_, _state), do: []

  @impl true
  def overview(state) do
    %{latest_release_name: state.latest_release.tag}
  end

  @impl true
  def apply(_meta, {:latest_release, latest_release}, effects, state) do
    new_state = %__MODULE__{state | latest_release: latest_release}
    {new_state, effects, :ok}
  end

  def apply(_meta, :show, effects, state) do
    {state, effects, state.latest_release}
  end
end
