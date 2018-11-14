defmodule Commands do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def create_inventory_item(server, id, name) do
    GenServer.call(server, {:create_inventory_item, id, name})
  end

  # GenServer implementation

  def init(:ok) do
    {:ok, Commands.new()}
  end

  def handle_call(request, from, state) do
    case request do
      {:create_inventory_item, id, name} ->
        {:reply, :ok, handle_create_inventory_item(state, id, name)}
    end
  end

  # Commands handlers
  @type t :: %Commands{repo: map()}

  defstruct [:repo]

  @spec new() :: Commands.t()
  def new do
    %Commands{
      repo: %{}
    }
  end

  #TODO: make Commands a GenServer to introduce C

  @spec handle_create_inventory_item(Commands.t(), any(), String.t()) :: Commands.t()
  def handle_create_inventory_item(state, id, name) do
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
