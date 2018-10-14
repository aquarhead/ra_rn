# RaRn

[Ra](https://github.com/rabbitmq/ra)-based (GitHub) release notifier.

## Playground

```
{:ok, [server | _], _} = RaRn.track_repo("elixir-lang/elixir")
RaRn.ReleaseChecker.start_link("elixir-lang", "elixir", server)
:ra.process_command(server, :show)
```
