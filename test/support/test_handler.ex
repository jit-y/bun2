defmodule TestHandler do
  use Bun2.Handler

  incoming ~r/foo/, msg do
    msg.message
  end
end
