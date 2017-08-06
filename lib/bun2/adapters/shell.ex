defmodule Bun2.Adapters.Shell do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{conn: self()}, name: __MODULE__)
  end

  def init(opts) do
    GenServer.cast(self(), :after_init)
    GenServer.cast(self(), :gets)
    {:ok, opts}
  end

  def handle_cast(:after_init, state) do
    message = """
    start
    """
    message
    |> IO.ANSI.format()
    |> IO.puts()
    {:noreply, state}
  end

  def handle_cast(:gets, state) do
    me = self()
    Task.start fn -> send(me, gets()) end
    {:noreply, state}
  end

  def handle_info(text, %{conn: conn} = state) when is_binary(text) do
    send(conn, {:message, String.trim(text)})
    Process.sleep(500)
    GenServer.cast(self(), :gets)
    {:noreply, state}
  end

  def handle_info({:reply, %{text: text}}, state) do
    IO.puts text
    {:noreply, state}
  end

  defp gets do
    prompt()
    |> IO.ANSI.format()
    |> IO.gets()
  end

  defp prompt do
    [:red, :bright, "(\\( ⁰⊖⁰)/)", "> ", :normal, :default_color]
  end
end
