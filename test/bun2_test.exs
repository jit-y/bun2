defmodule Bun2Test do
  use ExUnit.Case
  doctest Bun2

  test "greets the world" do
    assert Bun2.hello() == :world
  end
end
