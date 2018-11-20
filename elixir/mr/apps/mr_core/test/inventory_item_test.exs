defmodule InventoryItemTest do
  use ExUnit.Case

  doctest InventoryItem

  test "cannot deactivate a deactivated item" do
    item = InventoryItem.create(1, "name01")
    item = InventoryItem.deactivate(item)

    assert_raise RuntimeError, "already deactivated", fn ->
      InventoryItem.deactivate(item)
    end
  end
end
