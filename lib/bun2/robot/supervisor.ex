defmodule Bun2.Robot.Supervisor do
  @moduledoc false
  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      {Bun2.Robot, restart: :transient}
    ]
    Supervisor.init(children, strategy: :simple_one_for_one)
  end
end
