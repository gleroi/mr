defmodule InventoryItem do
  defstruct [:id, :name, activated: true, count: 0]

  def create(id, name) do
    %InventoryItem{
      id: id,
      name: name
    }
  end

  def change_name(item, name) do
    %{item | name: name}
  end

  def remove(item, count) do
    %{item | count: item.count - count}
  end

  def checkin(item, count) do
    %{item | count: item.count + count}
  end
end
