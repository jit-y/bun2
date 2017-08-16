defmodule Bun2.Handlers.Ping do
  @moduledoc """
  """
  use Bun2.Handler

  incoming ~r/ping/, _msg do
    reply "pong"
  end
end
