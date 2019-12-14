defmodule DoorOwl.TagDetector do
  use GenServer
  require Logger

  @name __MODULE__

  # API

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def add_tag(id) do
    Logger.debug("adding #{id}")
    GenServer.cast(@name, {:add, id})
  end

  def delete_tag(id) do
    Logger.debug("removing #{id}")
    GenServer.cast(@name, {:delete, id})
  end

  def tags_in_range() do
    Logger.debug("getting tags")
    GenServer.call(@name, :tags)
  end

  # Callbacks

  def init(:ok) do
    {:ok, %{}}
  end
  def init(state), do: {:ok, state}

  def handle_cast({:add, id}, state) do
    Logger.debug("handle adding #{id} from #{map_to_str(state)}")
    new_state = Map.put(state, id, "This should probably be a set instead of a map lol")
    {:noreply, new_state}
  end

  def handle_cast({:delete, id}, state) do
    Logger.debug("handle removing #{id} from #{map_to_str(state)}")
    new_state = Map.delete(state, id)
    {:noreply, new_state}
  end

  def handle_call(:tags, _from, state) do
    Logger.debug("handle returning state: #{map_to_str(state)}")
    {:reply, state, state}
  end

  defp map_to_str(map), do: Enum.map_join(map, ", ", fn {key, val} -> ~s{"#{key}", "#{val}"} end)
end
