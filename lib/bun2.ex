defmodule Bun2 do
  @moduledoc """

  """

  use Application

  def start(_type, _args) do
    Bun2.Supervisor.start_link
  end
end
