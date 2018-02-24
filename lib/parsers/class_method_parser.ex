defmodule PlantUmlParser.ClassMethodParser do
  alias PlantUmlParser.MethodParser, as: MethodParser
  alias PlantUmlParser.Class, as: Class

  @type state :: PlantUmlParser.state
  @type block :: String.t

  @spec parse_public_method(state, block) :: state
  def parse_public_method(state, method_block) do
    state
    |> Class.add_method(MethodParser.parse_public_method(method_block))
  end

  @spec parse_private_method(state, block) :: state
  def parse_private_method(state, method_block) do
    state
    |> Class.add_method(MethodParser.parse_private_method(method_block))
  end
end
