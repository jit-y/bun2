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

  # credo:disable-for-next-line
  defmacro __before_compile__(_env) do
    quote location: :keep do
      use GenServer

      def start_link(opts) do
        GenServer.start_link(__MODULE__, opts, name: __MODULE__)
      end

      def receive(handler, msg) do
        GenServer.cast(handler, {:dispatch, msg})
      end

      def reply(text) do
        GenServer.cast(self(), {:reply, text})
      end

      def init(%{robot: robot, name: name}) do
        GenServer.cast(self(), :setup_responses)
        {:ok, %{robot: robot, name: name, responses: []}}
      end

      def handle_info({:deliver, msg}, state) do
        GenServer.cast(self(), {:respond, msg})
        {:noreply, state}
      end

      def handle_cast(:setup_responses, %{name: name} = state) do
        {:noreply, %{state | responses: convert_responses(name)}}
      end

      def handle_cast({:dispatch, %{message: text} = msg}, %{responses: responses} = state) do
        Enum.each responses, fn {regex, function_name} ->
          if Regex.match?(regex, text) do
            new_msg = Map.put(msg, :matches, find_captures(regex, text))
            apply(__MODULE__, function_name, [new_msg, state])
          end
        end
        {:noreply, state}
      end

      def handle_cast({:reply, text}, %{robot: robot} = state) do
        Bun2.Robot.reply(robot, %{text: text})
        {:noreply, state}
      end

      defp find_captures(regex, text) do
        for {key, val} <- Regex.named_captures(regex, text), into: %{}, do: {String.to_atom(key), val}
      end

      defp convert_responses(name) do
        for {regex, function_name} <- @incoming, do: {convert_regex(regex, name), function_name}
      end

      defp convert_regex(regex, name) do
        regex
        |> Regex.source
        |> convert_source(name)
        |> Regex.compile!(Regex.opts(regex))
      end

      defp convert_source(message, name) do
        "^@?(?<name>#{name})\s*(?<message>#{message})"
      end
    end
  end
end
