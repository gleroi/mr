defmodule InventoryItem do
  defstruct [:id, :name, activated: true, count: 0, events: []]

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

  def apply_new_event(item, event) do
    item = apply_event(item, event)
    %{item | events: item.events ++ [event]}
  end

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
