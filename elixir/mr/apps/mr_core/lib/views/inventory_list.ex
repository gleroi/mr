defmodule Views.InventoryList do
  defmodule Item do
    defstruct [:id, :name]
  end

  def new() do
    Map.new()
  end

  def handle_event(list, event) do
    case event do
      {:inventory_item_created, data} ->
        Map.put(list, data[:id], %Item{id: data[:id], name: data[:name]})

      {:inventory_item_renamed, data} ->
        {_, map} = Map.get_and_update(list, data[:id], fn it ->
            {it, %Item{it | name: data[:name]}}
          end)
        map

      {:inventory_item_deactivated, [id: id]} ->
        Map.delete(list, id)
    end
  end
end
