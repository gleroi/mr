defmodule Repository.EventStore do
  use GenServer

  alias EventStore, as: ES

  def start_link(agg_module, opts) do
    GenServer.start_link(__MODULE__, [:ok, agg_module], opts)
  end

  def init([:ok, agg_module]) do
    {:ok, %{agg_module: agg_module, store: %{}}}
  end

  def handle_call(request, _from, state) do
    case request do
      {:get_by_id, id} ->
        events = ES.get_events_for_id(state.store, id)
        item = apply(state.agg_module, :load_from_history, [events])
        {:reply, item, state}
      {:save, id, item} ->
        store = ES.save_events(state.store, id, item.events)
        {:reply, :ok, %{ state | store: store }}
    end
  end

end
