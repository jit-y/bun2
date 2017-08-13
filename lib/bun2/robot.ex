defmodule Bun2.Robot do
  @moduledoc """
  """
  use GenServer
  defstruct adapter: nil,
            handler: nil,
            adapter_mod: nil,
            handler_mod: nil

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def deliver(robot, msg) do
    GenServer.cast(robot, {:deliver, %{msg: msg, robot: self()}})
  end

  def reply(pid, text) do
    GenServer.cast(pid, {:reply, text})
  end

  def init(_opts) do
    GenServer.cast(self(), :setup)
    {:ok, %Bun2.Robot{}}
  end

  def handle_cast({:deliver, msg}, %Bun2.Robot{handler_mod: handler_mod, handler: handler} = state) do
    handler_mod.receive(handler, msg)
    {:noreply, state}
  end

  def handle_cast({:reply, msg}, %Bun2.Robot{adapter_mod: adapter_mod, adapter: adapter} = state) do
    adapter_mod.receive(adapter, msg)
    {:noreply, state}
  end

  def handle_cast(:setup, state) do
    with {:ok, adapter_mod} <- Application.fetch_env(:bun2, :adapter),
         {:ok, handler_mod} <- Application.fetch_env(:bun2, :handler),
         {:ok, adapter} <- adapter_mod.start_link(),
         {:ok, handler} <- handler_mod.start_link() do
          {:noreply, %Bun2.Robot{state | adapter: adapter, handler: handler, adapter_mod: adapter_mod, handler_mod: handler_mod}}
    else
      :error -> {:stop, {:incorrect_config, "Adapter and Handler modules are not set correctly in config files"}, state}
      _ -> {:stop, :normal, "Error has occuered."}
    end
  end
end
