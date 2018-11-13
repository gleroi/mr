defmodule MrCoreTest do
  use ExUnit.Case
  doctest MrCore

  test "greets the world" do
    assert MrCore.hello() == :world
  end
end
