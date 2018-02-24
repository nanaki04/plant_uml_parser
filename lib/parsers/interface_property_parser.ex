defmodule PlantUmlParser.InterfacePropertyParser do
  alias PlantUmlParser.PropertyParser, as: PropertyParser
  alias CodeParserState.Interface, as: Interface

  @type state :: CodeParserState.state
  @type block :: String.t

  @spec parse_public_property(state, block) :: state
  def parse_public_property(state, property_block) do
    state
    |> Interface.add_property(PropertyParser.parse_public_property(property_block))
  end

  @spec parse_private_property(state, block) :: state
  def parse_private_property(state, property_block) do
    state
    |> Interface.add_property(PropertyParser.parse_private_property(property_block))
  end

end
