defmodule RabbitmqTutorialTest do
  use ExUnit.Case
  doctest RabbitmqTutorial

  test "greets the world" do
    assert RabbitmqTutorial.hello() == :world
  end
end
