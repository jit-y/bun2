defmodule Bun2.AdapterTest do
  use ExUnit.Case, async: true
  setup do
    {:ok, adapter} = TestAdapter.start_link()
    {:ok, %{adapter: adapter}}
  end

  describe "#receive" do
    test "is valid", %{adapter: adapter} do
      assert :ok == TestAdapter.receive(adapter, "foo")
    end
  end

  describe "#deliver" do
    test "is valid" do
      Application.put_env(:bun2, :handlers, [TestHandler], persistent: true)
      Application.put_env(:bun2, :adapter, TestAdapter, persistent: true)
      Application.put_env(:bun2, :name, "foo", persistent: true)
      {:ok, robot} = Bun2.Robot.start_link(%{})
      assert :ok == TestAdapter.deliver(robot, "foo")
    end
  end
end
