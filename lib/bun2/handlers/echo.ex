defmodule Bun2.Handlers.Echo do
  @moduledoc """
  """
  use Bun2.Handler

  incoming ~r/(.+)/, msg do
    reply msg.matches[0]
  end
end
