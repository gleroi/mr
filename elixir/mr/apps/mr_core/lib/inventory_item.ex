defmodule InventoryItem do

  defstruct [:id, :name, activated: true, count: 0, events: []]
  @type t :: %InventoryItem{name: String.t, count: integer, events: list}


  @spec create(any, String.t) :: InventoryItem.t
  def create(id, name) do
    apply_new_event(nil, {:inventory_item_created, [id: id, name: name]})
  end

  def change_name(item, name) do
    apply_new_event(item, {:inventory_item_renamed, [id: item.id, name: name]})
  end

  def checkout(item, count) do
    apply_new_event(item, {:inventory_item_checked_out, [id: item.id, count: count]})
  end

  def checkin(item, count) do
    apply_new_event(item, {:inventory_item_checked_in, [id: item.id, count: count]})
  end

  def deactivate(item) do
    if !item.activated do
      raise "already deactivated"
    end
    apply_new_event(item, {:inventory_item_deactivated, [id: item.id]})
  end

  @spec apply_new_event(t, event_t) :: t
  def apply_new_event(item, event) do
    item = apply_event(item, event)
    %{item | events: item.events ++ [event]}
  end

  @type event_created :: {:inventory_item_created, [{:id, any}, {:name, String.t}]}
  @type event_deactivated :: {:inventory_item_deactivated, [{:id, any}]}
  @type event_renamed :: {:inventory_item_renamed, [{:id, any}, {:name, String.t}]}
  @type event_checked_in :: {:inventory_item_checked_in, [{:id, any}, {:count, integer}]}
  @type event_checked_out :: {:inventory_item_checked_out, [{:id, any}, {:count, integer}]}

  @type event_t :: event_created | event_deactivated | event_renamed | event_checked_in | event_checked_out

  @spec apply_event(t, event_t) :: t
  def apply_event(item, event) do
    case event do
      {:inventory_item_created, [id: id, name: name]} ->
        %InventoryItem{id: id, name: name}
      {:inventory_item_deactivated, _} ->
        %{item | activated: false}
      {:inventory_item_renamed, [id: _id, name: name]} ->
        %{item | name: name}
      {:inventory_item_checked_in, [id: _id, count: count]} ->
        %{item | count: item.count + count}
      {:inventory_item_checked_out, [id: _id, count: count]} ->
        %{item | count: item.count - count}
    end
  end

  def load_from_history(events) do
    Enum.reduce(events, nil, fn evt, item -> apply_event(item, evt) end)
  end
end
