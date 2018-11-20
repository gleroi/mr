defmodule Views.InventoryListTest do
  use ExUnit.Case

  alias Views.InventoryList

  doctest Views.InventoryList

  test "inventory_item_created add an element to the list" do
    list = InventoryList.new()
    list = InventoryList.handle_event(list, {:inventory_item_created, [id: 1, name: "name01"]})

    assert Map.has_key?(list, 1)
    assert Map.fetch!(list, 1).name == "name01"
  end

end
