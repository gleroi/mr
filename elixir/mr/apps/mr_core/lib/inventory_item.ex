defmodule InventoryItem do
  defstruct [:id, :name, activated: true, count: 0, events: []]

  def create(id, name) do
    %InventoryItem{
      id: id,
      name: name,
      events: [
        {:inventory_item_created, [id: id, name: name]}
      ]
    }
  end

  def change_name(item, name) do
    %{item | name: name,
      events: item.events ++ [
        {:inventory_item_renamed, [id: item.id, name: name]}
      ]
    }
  end

  def checkout(item, count) do
    %{item | count: item.count - count,
      events: item.events ++ [
          {:inventory_item_checked_out, [id: item.id, count: count]}
      ]
    }
  end

  def checkin(item, count) do
    %{item | count: item.count + count,
    events: item.events ++ [
        {:inventory_item_checked_in, [id: item.id, count: count]}
    ]
  }
  end

  def deactivate(item) do
    if !item.activated do
      raise "already deactivated"
    end
    %{item | activated: false,
    events: item.events ++ [
        {:inventory_item_deactivated, [id: item.id]}
    ]
  }
  end
end
