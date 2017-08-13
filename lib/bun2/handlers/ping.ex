defmodule Bun2.Handlers.Ping do
  use Bun2.Handler

  incoming ~r/ping/, _msg, %{robot: robot} do
    send robot, {:reply, %{text: "pong"}}
  end
end
