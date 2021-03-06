defmodule CommandsTest do
  use ExUnit.Case

  doctest Commands

  def new_repository() do
    {:ok, repo} = Repository.EventStore.start_link(InventoryItem, [])
    repo
  end

  test "create should save to repository" do
    repo = new_repository()
    state = Commands.new(repo)
    state = Commands.create_inventory_item(state, 1, "item name")

    assert Repository.get_by_id(state.repo, 1) != nil
    assert Repository.get_by_id(state.repo, 1).id == 1
    assert Repository.get_by_id(state.repo, 1).name == "item name"
    assert Repository.get_by_id(state.repo, 1).activated == true
    assert Repository.get_by_id(state.repo, 1).count == 0
  end

  test "checkin shoud increment count" do
    repo = new_repository()
    state = Commands.new(repo)
    state = Commands.create_inventory_item(state, 1, "item name")

    state = Commands.checkin_items_into_inventory(state, 1, 5)

    assert Repository.get_by_id(state.repo, 1).count == 5
  end

  test "checkout shoud decrement count" do
    repo = new_repository()
    state = Commands.new(repo)
    state = Commands.create_inventory_item(state, 1, "item name")
    state = Commands.checkin_items_into_inventory(state, 1, 5)

    state = Commands.checkout_items_from_inventory(state, 1, 4)

    assert Repository.get_by_id(state.repo, 1).count == 1
  end

  test "rename should change name of item" do
    repo = new_repository()
    state = Commands.new(repo)
    state = Commands.create_inventory_item(state, 1, "item name")

    state = Commands.rename_inventory_item(state, 1, "new name")

    assert Repository.get_by_id(state.repo, 1).name == "new name"
  end

  test "deactivate should mark item as inactive" do
    repo = new_repository()
    state = Commands.new(repo)
    state = Commands.create_inventory_item(state, 1, "item name")

    state = Commands.deactivate_inventory_item(state, 1)

    assert Repository.get_by_id(state.repo, 1).activated == false
  end
end
