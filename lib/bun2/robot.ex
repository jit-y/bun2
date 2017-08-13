defmodule Bun2.Robot do
  @moduledoc """
  """
  use GenServer
  defstruct adapter: nil, handler: nil

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def deliver(robot, msg) do
    GenServer.cast(robot, {:deliver, %{msg: msg, robot: self()}})
  end

  def reply(pid, text) do
    GenServer.cast(pid, {:reply, text})
  end

  def init(_state) do
    {:ok, adapter} = Bun2.Adapters.Shell.start_link()
    {:ok, handler} = Bun2.Handlers.Echo.start_link()
    {:ok, %Bun2.Robot{adapter: adapter, handler: handler}}
  end

  def handle_cast({:deliver, msg}, %Bun2.Robot{handler: handler} = state) do
    send(handler, {:deliver, msg})
    {:noreply, state}
  end

  def handle_cast({:reply, msg}, %Bun2.Robot{adapter: adapter} = state) do
    send(adapter, {:reply, msg})
    {:noreply, state}
  end

  def handle_info({:message, text}, %Bun2.Robot{handler: handler} = state) when is_binary(text) do
    send(handler, {:message, %{text: text, robot: self()}})
    {:noreply, state}
  end
end
