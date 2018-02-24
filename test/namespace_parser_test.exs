defmodule PlantUmlParser.NamespaceParserTest do
  use ExUnit.Case
  doctest PlantUmlParser.NamespaceParser
  import PlantUmlParser.NamespaceParser
  alias PlantUmlParser.FileParser, as: FileParser

  test "parses a namespace into a number of child objects" do
    %PlantUmlParser{}
    |> FileParser.parse_file("test/test.uml")
    |> (fn %{files: files} ->
      assert %{namespaces: [%{classes: classes1}, %{classes: classes2}, %{classes: classes3}]} = hd(files)
      IO.inspect(classes1)
      IO.inspect(classes2)
      IO.inspect(classes3)
    end).()
  end
end
