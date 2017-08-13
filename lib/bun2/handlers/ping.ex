defmodule Bun2.Handlers.Ping do
  use Bun2.Handler

  incoming ~r/ping/, _msg do
    reply "pong"
  end
end
