defmodule Views.InventoryList do

  defmodule Item do
    defstruct [:id, :name]
  end

  def new() do
    %{}
  end


  def handle_event(list, event) do
    case event do
      {:inventory_item_created, data} ->
        Map.put(list, data.id, %{id: data.id, name: data.name})
    end
  end

end
