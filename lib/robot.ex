defmodule Bun2.Robot do
  @moduledoc """
  """
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    IO.puts "aaaaa"
    {:ok, state}
  end
end
