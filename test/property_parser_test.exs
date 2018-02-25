defmodule PlantUmlParser.PropertyParserTest do
  use ExUnit.Case
  doctest PlantUmlParser.PropertyParser
  import PlantUmlParser.PropertyParser

  test "parses a property with name only" do
    property = parse_public_property("count")
    assert property.name == "count"
  end

  test "parses a property with type and name" do
    property = parse_public_property("List<int> CountList")
    assert property.name == "CountList"
    assert property.type == "List<int>"
  end

  test "parses a property with name and comment" do
    property = parse_public_property("CountList // a list with count values")
    assert property.name == "CountList"
    assert property.description == "a list with count values"
  end

  test "parses a property with type, name, and comment" do
    property = parse_public_property("List<int> CountList // a list with count values")
    assert property.name == "CountList"
    assert property.type == "List<int>"
    assert property.description == "a list with count values"
  end

  test "parses a constant" do
    property = parse_public_property("const List<int> FIXED_COUNT_LIST")
    assert property.accessibility == "public const"
    assert property.type == "List<int>"
    assert property.name == "FIXED_COUNT_LIST"
  end

  test "parses a constant with comment" do
    property = parse_public_property("const List<int> FIXED_COUNT_LIST // a predetermined list with count values")
    assert property.accessibility == "public const"
    assert property.type == "List<int>"
    assert property.name == "FIXED_COUNT_LIST"
    assert property.description == "a predetermined list with count values"
  end

end
