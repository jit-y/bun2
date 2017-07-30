defmodule Bun2.Rubot.Supervisor do
  @moduledoc false
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, [], opts)
  end

  def init(_) do
    children = [
      {Bun2.Robot, restart: :transient}
    ]
    Supervisor.init(children, strategy: :simple_one_for_one)
  end
end
