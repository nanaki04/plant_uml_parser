defmodule PlantUmlParserTest do
  use ExUnit.Case
  doctest PlantUmlParser

  test "greets the world" do
    assert PlantUmlParser.hello() == :world
  end
end
