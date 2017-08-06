defmodule Bun2.Handlers.Echo do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    {:ok, %{}}
  end

  def handle_info({:message, %{text: text, robot: robot}}, state) do
    send(robot, {:reply, %{text: text}})
    {:noreply, state}
  end
end
