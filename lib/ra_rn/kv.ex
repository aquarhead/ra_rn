defmodule RaRn.KV do
  @behaviour :ra_machine

  def init(_) do
    Map.new()
  end

  def apply(_meta, {:write, key, value}, effects, state) do
    {Map.put(state, key, value), effects, :ok}
  end

  def apply(_meta, {:read, key}, effects, state) do
    reply = Map.get(state, key, :undefined)
    {state, effects, reply}
  end

  def start() do
    servers = [{:kv1, node()}, {:kv2, node()}, {:kv3, node()}]
    cluster_id = "kv!"
    machine = {:module, __MODULE__, Map.new()}
    Application.ensure_all_started(:ra)
    :ra.start_cluster(cluster_id, machine, servers)
  end
end
