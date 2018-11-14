defmodule Commands do
  @type t :: %Commands{repo: map()}

  defstruct [:repo]

  @spec new() :: Commands.t()
  def new do
    %Commands{
      repo: %{}
    }
  end

  @spec create_inventory_item(Commands.t(), any(), String.t()) :: Commands.t()
  def create_inventory_item(state, id, name) do
    item = InventoryItem.create(id, name)
    %{state | repo: Repository.save(state.repo, id, item) }
  end

  def checkin_items_into_inventory(state, id, count) do
    item = Repository.get_by_id(state.repo, id)
    item = InventoryItem.checkin(item, count)
    %{state | repo: Repository.save(state.repo, id, item)}
  end

  def checkout_items_from_inventory(state, id, count) do
    item = Repository.get_by_id(state.repo, id)
    item = InventoryItem.checkout(item, count)
    %{state | repo: Repository.save(state.repo, id, item)}
  end

  def rename_inventory_item(state, id, name) do
    item = Repository.get_by_id(state.repo, id)
    item = InventoryItem.change_name(item, name)
    %{state | repo: Repository.save(state.repo, id, item)}
  end

  def deactivate_inventory_item(state, id) do
    item = Repository.get_by_id(state.repo, id)
    item = InventoryItem.deactivate(item)
    %{state | repo: Repository.save(state.repo, id, item)}
  end

end
