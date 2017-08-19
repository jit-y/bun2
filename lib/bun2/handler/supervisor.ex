defmodule Bun2.Handler.Supervisor do
  @moduledoc """
  """
  def start_link do
    Supervisor.start_link(__MODULE__, %{robot: self()}, name: __MODULE__)
  end

  def init(opts) do
    with {:ok, modules} <- Application.fetch_env(:bun2, :handlers),
         children <- modules |> Enum.map(fn(mod) -> {mod, opts} end) do
          Supervisor.init(children, strategy: :one_for_one)
    end
  end
end
