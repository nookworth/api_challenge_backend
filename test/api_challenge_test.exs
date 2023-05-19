defmodule ApiChallengeTest do
  use ExUnit.Case
  doctest ApiChallenge

  test "greets the world" do
    assert ApiChallenge.hello() == :world
  end
end
