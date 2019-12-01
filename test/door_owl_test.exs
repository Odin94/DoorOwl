defmodule DoorOwlTest do
  use ExUnit.Case
  doctest DoorOwl

  test "greets the world" do
    assert DoorOwl.hello() == :world
  end
end
