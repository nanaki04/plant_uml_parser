defmodule BlockParserTest do
  use ExUnit.Case
  doctest PlantUmlParser.BlockParser

  test "divides code blocks" do
    PlantUmlParser.BlockParser.parse(File.read! "test/test.uml")
    |> (fn result ->
      assert result == %{
        "global" => [
          "class GlobalClass {\n  -List<int> _cache\n  +int GetCache(int index)\n}"
        ],
        "namespace UI.Scripts.PageView.TestEvent {\n  \n}" => [
          "class TestEventView {\n    +Animator animation\n    +void Bind(TestEventViewModel viewModel)\n  }"
        ],
        "namespace UI.Scripts.PageViewModel.TestEvent {\n  \n\n  \n\n  \n}" => [
          "interface ITestHeaderViewModel {\n    +string TestImageResourceID\n  }",
          "class TestHeaderViewModel {\n    +string TestImageResourceID\n  }",
          "class TestEventViewModel {\n    +string Id\n    -int _count\n    +void OnClick(int buttonType, string id)\n    -int GetCount()\n  }"
        ]
      }
    end).()
  end
end
