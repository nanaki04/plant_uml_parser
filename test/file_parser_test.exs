defmodule PlantUmlParser.FileParserTest do
  use ExUnit.Case
  doctest PlantUmlParser.FileParser
  import PlantUmlParser.FileParser

  test "parses a file into a number of namespace objects" do
    %PlantUmlParser{}
    |> parse_file("test/test.uml")
    |> (fn %{files: files} ->
      assert hd(files).name == "test/test.uml"
      assert %{namespaces: [%{name: name1}, %{name: name2}, %{name: name3}]} = hd(files)
      assert name1 == "UI.Scripts.PageViewModel.TestEvent"
      assert name2 == "UI.Scripts.PageView.TestEvent"
      assert name3 == "global"
    end).()
  end
end
