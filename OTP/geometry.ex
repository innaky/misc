defmodule Geometry do
  use GenServer

  @impl true
  def init(value) when value == nil do
    {:ok, value}
  end

  def init(_) do
    {:stop, "Fail, the value must be nil."}
  end
  
  @impl true
  def handle_call({:triangle, base, height}, _from, state) do
    {:reply, triangle_area(base, height), state}
  end

  @impl true
  def handle_call({:rectangle, long, width}, _from, state) do
    {:reply, rectangle_area(long, width), state}
  end

  @impl true
  def terminate(reason, state) do
    IO.puts("#{__MODULE__} terminate - reason #{inspect(reason)} state: #{inspect(state, pretty: true)}")
  end

  defp triangle_area(base, height) do
    base * (height/2)
  end

  defp rectangle_area(long, width) do
    long * width
  end
  
  def start(value \\ nil) do
    GenServer.start_link(__MODULE__, value, name: __MODULE__)
  end

  def triangle(base, height) do
    GenServer.call(__MODULE__, {:triangle, base, height})
  end

  def rectangle(long, width) do
    GenServer.call(__MODULE__, {:rectangle, long, width})
  end

  def stop() do
    GenServer.cast(__MODULE__, :stop)
  end
end
