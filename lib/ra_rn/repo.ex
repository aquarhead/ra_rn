defmodule RaRn.Repo do
  @behaviour :ra_machine

  defstruct [
    :repo,
    :latest_release
  ]

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
  def apply(_meta, {:latest_release, latest_release}, effects, state) do
    new_state = %__MODULE__{state | latest_release: latest_release}
    {new_state, effects, :ok}
  end

  def apply(_meta, {:new_releases, new_releases}, effects, state) do
    output_cmd = {:mod_call, IO, :inspect, [new_releases]}
    new_state = %__MODULE__{state | latest_release: Enum.at(new_releases, 0)}

    {new_state, [output_cmd | effects], :ok}
  end

  def apply(_meta, :show, effects, state) do
    {state, effects, state.latest_release}
  end
end
