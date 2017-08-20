defmodule Bun2.RobotTest do
  use ExUnit.Case, async: true
  @moduletag handlers: [TestHandler], adapter: TestAdapter, name: "bun2"

  setup context do
    Application.put_env(:bun2, :handlers, context[:handlers], persistent: true)
    Application.put_env(:bun2, :adapter, context[:adapter], persistent: true)
    Application.put_env(:bun2, :name, context[:name], persistent: true)
    {:ok, robot} = Bun2.Robot.start_link(%{})
    {:ok, %{robot: robot, state: %Bun2.Robot{}}}
  end

  describe "#deliver/2" do
    test "is valid", %{robot: robot} do
      assert :ok == Bun2.Robot.deliver(robot, "foo")
    end
  end

  describe "#receive/2" do
    test "is valid", %{robot: robot} do
      assert :ok == Bun2.Robot.reply(robot, "bar")
    end
  end
end
