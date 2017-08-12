defmodule Bun2.Handlers.Echo do
  use Bun2.Handler

  incoming ~r/ping/, msg, %{robot: robot} do
    send robot, {:reply, %{text: "pong"}}
  end

  def handle_info({:dispatch, %{msg: msg, robot: robot}}, state) do
    send(robot, {:reply, %{text: msg}})
    {:noreply, state}
  end
end
