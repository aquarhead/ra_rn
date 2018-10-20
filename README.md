# RaRn

[Ra](https://github.com/rabbitmq/ra)-based (GitHub) release notifier.

## Playground

```
[server | _] = RaRn.track_repo("elixir-lang/elixir")
RaRn.Repo.query_latest_release(server)
```
