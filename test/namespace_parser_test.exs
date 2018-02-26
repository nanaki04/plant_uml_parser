defmodule PlantUmlParser.NamespaceParserTest do
  use ExUnit.Case
  doctest PlantUmlParser.NamespaceParser
  alias PlantUmlParser.FileParser, as: FileParser

  test "parses a namespace into a number of child objects" do
    %CodeParserState{}
    |> FileParser.parse_file("test/test.uml")
    |> (fn %{files: files} ->
      assert %{namespaces: [%{classes: _classes1}, %{classes: _classes2}, %{classes: _classes3}]} = hd(files)
    end).()
  end
end
