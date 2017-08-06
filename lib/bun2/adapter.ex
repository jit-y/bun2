defmodule Bun2.Adapter do
  @moduledoc """
    use Bun2.Adapter
  """
  use GenServer
  def start_link do
    GenServer.start_link(__MODULE__, {self(), __MODULE__}, name: __MODULE__)
  end

  def init(state) do
    GenServer.cast(self(), :after_init)
    {:ok, state}
  end

  def handle_cast(:after_init, state) do
    {:noreply, state}
  end
end
