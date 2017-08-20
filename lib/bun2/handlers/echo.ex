defmodule Bun2.Handlers.Echo do
  @moduledoc """
  """
  use Bun2.Handler

  incoming ~r/(.+)/, msg do
    reply msg.matches[:message]
  end
end
