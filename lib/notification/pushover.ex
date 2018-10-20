defmodule RaRn.Notification.Pushover do
  @behaviour RaRn.Notification

  defmodule PushoverClient do
    use Tesla

    plug Tesla.Middleware.Headers, [
      {"user-agent", "github.com/aquarhead/ra_rn"}
    ]

    plug Tesla.Middleware.JSON
    plug Tesla.Middleware.BaseUrl, "https://api.pushover.net/1"
  end

  @impl true
  def child_spec(_, _) do
    nil
  end

  @impl true
  def notify(id, repo, release) do
    {_module, args} = Application.get_env(:ra_rn, :notifications)[id]

    message = "project: #{repo}\nrelease: #{release.tag}\n\n#{release.url}"

    body =
      URI.encode_query(%{
        token: args[:token],
        user: args[:user],
        message: message
      })

    PushoverClient.post("/messages.json", body)
  end
end
