defmodule PlantUmlParserTest do
  use ExUnit.Case
  doctest PlantUmlParser

  test "that it parses plant uml files" do
    result = PlantUmlParser.parse("test/test.uml")
    assert result = %CodeParserState{}
  end
end
