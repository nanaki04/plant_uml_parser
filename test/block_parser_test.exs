defmodule BlockParserTest do
  use ExUnit.Case
  doctest PlantUmlParser.BlockParser

  test "divides code blocks" do
    PlantUmlParser.BlockParser.parse(File.read! "test/test.uml")
    |> (fn result ->
      assert result == %{
        "global" => [
          "class GlobalClass { // global class comment\n  -List<int> _cache // caches stuff\n  +int GetCache(int index) // gets cache\n}"
        ],
        "namespace UI.Scripts.PageViewModel.TestEvent {\n  \n\n  \n\n  \n}" => [
          "interface ITestHeaderViewModel { // comment 4\n    +string TestImageResourceID\n  }",
          "class TestHeaderViewModel { // comment 3\n    +string TestImageResourceID\n  }",
          "class TestEventViewModel { // comment 2\n    +string Id\n    -int _count\n    +void OnClick(int buttonType, string id)\n    -int GetCount()\n  }"
        ],
        "namespace UI.Scripts.PageView.TestEvent {\n  \n\n  \n}" => [
          "enum ButtonType { // comment 6\n    Ok\n    Cancel\n  }",
          "class TestEventView { // comment 5\n    +Animator animation\n    +void Bind(TestEventViewModel viewModel)\n  }"
        ]
      }
    end).()
  end
end
