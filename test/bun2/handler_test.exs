defmodule Bun2.HandlerTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, handler} = TestHandler.start_link(%{robot: self(), name: "foo"})
    {:ok, %{handler: handler}}
  end

  describe "#receive" do
    test "is valid", %{handler: handler} do
      assert :ok == TestHandler.receive(handler, %{message: "foo"})
    end
  end

  describe "#reply" do
    test "is valid" do
      assert :ok == TestHandler.reply(%{message: "foo"})
    end
  end
end
