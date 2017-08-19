defmodule Bun2.Robot do
  @moduledoc """
  """
  use GenServer
  defstruct adapter: nil,
            adapter_mod: nil,
            handler_sup: nil,
            handlers: []

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def deliver(robot, msg) do
    GenServer.cast(robot, {:deliver, %{msg: msg, robot: self()}})
  end

  def reply(robot, text) do
    GenServer.cast(robot, {:reply, text})
  end

  def init(_opts) do
    GenServer.cast(self(), :setup)
    {:ok, %Bun2.Robot{}}
  end

  def handle_cast({:deliver, msg}, %Bun2.Robot{handlers: handlers} = state) do
    handlers
    |> Enum.each(fn({mod, pid, _, _}) -> mod.receive(pid, msg) end)
    {:noreply, state}
  end

  def handle_cast({:reply, msg}, %Bun2.Robot{adapter_mod: adapter_mod, adapter: adapter} = state) do
    adapter_mod.receive(adapter, msg)
    {:noreply, state}
  end

  def handle_cast(:setup, state) do
    with {:ok, adapter_mod} <- Application.fetch_env(:bun2, :adapter),
         {:ok, adapter} <- adapter_mod.start_link(),
         {:ok, handler_sup} <- Bun2.Handler.Supervisor.start_link(),
         handlers <- Supervisor.which_children(handler_sup) do
          {:noreply, %Bun2.Robot{state | adapter: adapter, adapter_mod: adapter_mod, handler_sup: handler_sup, handlers: handlers}}
    else
      :error -> {:stop, {:incorrect_config, "Adapter and Handler modules are not set correctly in config files"}, state}
      _ -> {:stop, :normal, "Error has occuered."}
    end
  end
end
