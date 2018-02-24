defmodule PlantUmlParser.EnumPropertyParser do
  alias PlantUmlParser.PropertyParser, as: PropertyParser
  alias CodeParserState.Enum, as: Enum

  @type state :: CodeParserState.state
  @type block :: String.t

  @spec parse_public_property(state, block) :: state
  def parse_public_property(state, property_block) do
    state
    |> Enum.add_property(PropertyParser.parse_public_property(property_block))
  end

  @spec parse_private_property(state, block) :: state
  def parse_private_property(state, property_block) do
    state
    |> Enum.add_property(PropertyParser.parse_private_property(property_block))
  end

end
