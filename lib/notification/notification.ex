defmodule RaRn.Notification do
  @callback child_spec(id :: atom(), args :: any()) :: nil | Supervisor.child_spec()

  @callback notify(id :: atom(), repo :: String.t(), release :: RaRn.ReleaseInfo.t()) ::
              :ok | {:error, any()}

  def notify_all(repo, release) do
    Task.start(fn ->
      Application.get_env(:ra_rn, :notifications)
      |> Enum.each(fn {id, {module, _}} ->
        module.notify(id, repo, release)
      end)
    end)
  end
end
