defmodule BlockParserTest do
  use ExUnit.Case
  doctest PlantUmlParser.BlockParser

  test "divides code blocks" do
    PlantUmlParser.BlockParser.parse(File.read! "test/test.uml")
    |> (fn result ->
      IO.inspect(result)
      assert true
    end).()
  end
end
