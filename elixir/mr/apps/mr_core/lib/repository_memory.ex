defmodule Repository.Memory do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call(request, _from, state) do
    case request do
      {:get_by_id, id} ->
        {:reply, Map.get(state, id, nil), state}
      {:save, id, item} ->
        state = Map.put(state, id, item)
        {:reply, :ok, state}
    end
  end

end
