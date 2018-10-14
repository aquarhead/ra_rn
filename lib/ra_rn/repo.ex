defmodule RaRn.Repo do
  @behaviour :ra_machine

  defstruct [
    :repo,
    :latest_release,
  ]

  @impl true
  def init(%{repo: repo}) do
    %__MODULE__{
      repo: repo,
      latest_release: nil,
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

  def apply(_meta, :show, effects, state) do
    {state, effects, state.latest_release}
  end
end
