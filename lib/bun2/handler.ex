defmodule Bun2.Handler do
  @moduledoc """
    use Bun2.Handler
  """

  defmacro __using__(_opts) do
    quote location: :keep do
      import unquote(__MODULE__)

      Module.register_attribute __MODULE__, :incoming, accumulate: true

      @before_compile unquote(__MODULE__)
    end
  end

  defmacro incoming(regex, msg, state \\ Macro.escape(%{}), do: block) do
    name = String.to_atom("incoming_#{System.unique_integer([:positive, :monotonic])}")
    quote do
      @incoming {unquote(regex), unquote(name)}
      def unquote(name)(unquote(msg), unquote(state)) do
        unquote(block)
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote location: :keep do
      use GenServer

      def start_link do
        GenServer.start_link(__MODULE__, %{robot: self()}, name: __MODULE__)
      end

      def receive(handler, msg) do
        GenServer.cast(handler, {:dispatch, msg})
      end

      def reply(text) do
        GenServer.cast(self(), {:reply, text})
      end

      def init(%{robot: robot}) do
        GenServer.cast(self(), :setup_responses)
        {:ok, %{robot: robot, responses: []}}
      end

      def handle_info({:deliver, msg}, state) do
        GenServer.cast(self(), {:respond, msg})
        {:noreply, state}
      end

      def handle_cast(:setup_responses, state) do
        {:noreply, %{state | responses: @incoming}}
      end

      def handle_cast({:dispatch, %{msg: text} = msg}, %{responses: responses} = state) do
        Enum.each responses, fn {regex, function_name} ->
          if Regex.match?(regex, text) do
            new_msg = Map.put(msg, :matches, find_matches(regex, text))
            apply(__MODULE__, function_name, [new_msg, state])
          end
        end
        {:noreply, state}
      end

      def handle_cast({:reply, text}, %{robot: robot} = state) do
        Bun2.Robot.reply(robot, %{text: text})
        {:noreply, state}
      end

      defp find_matches(regex, text) do
        case Regex.names(regex) do
          [] ->
            regex
            |> Regex.run(text)
            |> Enum.with_index()
            |> Enum.reduce(%{}, fn {match, index}, acc -> Map.put(acc, index, match) end)
          _ ->
            Regex.named_captures(regex, text)
        end
      end
    end
  end
end
