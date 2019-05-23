defmodule Commands do

  # Commands handlers

  defstruct [:repo]
  @type t :: %Commands{}

  @spec new(Repository.t) :: Commands.t()
  def new(repo) do
    %Commands{
      repo: repo
    }
  end

  @spec create_inventory_item(Commands.t(), any(), String.t()) :: Commands.t()
  def create_inventory_item(state, id, name) do
    item = InventoryItem.create(id, name)
    :ok = Repository.save(state.repo, id, item)
    state
  end

  def checkin_items_into_inventory(state, id, count) do
    item = Repository.get_by_id(state.repo, id)
    item = InventoryItem.checkin(item, count)
    :ok = Repository.save(state.repo, id, item)
    state
  end

  def checkout_items_from_inventory(state, id, count) do
    item = Repository.get_by_id(state.repo, id)
    item = InventoryItem.checkout(item, count)
    :ok = Repository.save(state.repo, id, item)
    state
  end

  def rename_inventory_item(state, id, name) do
    item = Repository.get_by_id(state.repo, id)
    item = InventoryItem.change_name(item, name)
    :ok = Repository.save(state.repo, id, item)
    state
  end

  def deactivate_inventory_item(state, id) do
    item = Repository.get_by_id(state.repo, id)
    item = InventoryItem.deactivate(item)
    :ok = Repository.save(state.repo, id, item)
    state
  end

end
