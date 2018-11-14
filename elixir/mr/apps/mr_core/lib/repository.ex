defmodule Repository do

  def get_by_id(rep, id) do
    Map.get(rep, id, nil)
  end

  def save(rep, id, item) do
    Map.put(rep, id, item)
  end

end
