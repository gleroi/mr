defmodule Repository do

  def get_by_id(rep, id) do
    GenServer.call(rep, {:get_by_id, id})
  end

  def save(rep, id, item) do
    GenServer.call(rep, {:save, id, item})
  end

end
