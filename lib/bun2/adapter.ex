defmodule Bun2.Adapter do
  @moduledoc """
    use Bun2.Adapter
  """

  defmacro __using__(_args) do
    quote location: :keep do
      import unquote(__MODULE__)

      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote location: :keep do
      use GenServer

      @doc false
      def start_link do
        GenServer.start_link(__MODULE__, %{robot: self()}, name: __MODULE__)
      end

      @doc """
      Interface called in Robot module.
      This function returns message which is delivered from handler via robot.
      """
      def receive(adapter, msg) do
        GenServer.cast(adapter, {:read, msg})
      end

      @doc """
      Interface called by adapter module.
      This function send message to handler via robot.
      """
      def deliver(robot, msg) do
        Bun2.Robot.deliver(robot, msg)
      end
    end
  end
end
