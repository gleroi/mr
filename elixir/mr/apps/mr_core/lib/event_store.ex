defmodule EventStore do
  defmodule EventDescriptor do
    @type t :: %EventDescriptor{id: any, version: integer, event_data: any}
    defstruct [:id, :event_data, version: 0]
  end

  def save_events(store, id, events) do
    agg_events = Map.get(store, id, [])
    evt_last = List.last(agg_events)
    last_version = if evt_last != nil do
      evt_last.version
    else
      0
    end

    {_version, next_agg_events} = Enum.reduce(events, {last_version, []}, fn evt, {version, list} ->
      {version + 1, list ++ [%EventDescriptor{id: id, version: version, event_data: evt}]}
    end)

    Map.put(store, id, agg_events ++ next_agg_events)
  end

  def get_events_for_id(store, id) do
    events = Map.get(store, id)
    if events == nil do
      raise "aggregate not found!"
    end
    Enum.map(events, fn evt -> evt.event_data end)
  end

end
