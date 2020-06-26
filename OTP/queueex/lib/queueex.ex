defmodule Queueex do
  use GenServer

  # Server Zone
  def init(state), do: {:ok, state}

  # sync

  def handle_call(:dequeue, _from, [value|state]) do
    {:reply, value, state}
  end

  def handle_call(:dequeue, _from, []) do
    {:reply, nil, []}
  end

  def handle_call(:queue, _from, state) do
    {:reply, state, state}
  end

  # async
  
  def handle_cast({:unqueue, value}, state) do
    if is_list(value) do
      {:noreply, [List.first(value) + 1 | state ]}
    else
      {:noreply, state ++ [value]}
    end
  end

  # Client zone
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def queue, do: GenServer.call(__MODULE__, :queue)
  def dequeue, do: GenServer.call(__MODULE__, :dequeue)
  def unqueue(value), do: GenServer.cast(__MODULE__, {:enqueue, value})
end
