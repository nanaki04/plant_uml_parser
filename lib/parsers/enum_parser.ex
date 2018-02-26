defmodule PlantUmlParser.EnumParser do
  alias CodeParserState.Enum, as: EnumParser

  @type state :: CodeParserState.state
  @type block :: String.t

  @spec parse_enum(state, block) :: state
  def parse_enum(state, enum_block) do
    state
    |> parse_name(enum_block)
    |> parse_properties(enum_block)
  end

  @spec parse_name(state, block) :: state
  defp parse_name(state, enum_block) do
    Regex.run(~r/(?<=\s)(\.|\w)+/, enum_block)
    |> (fn
      nil -> ""
      [] -> ""
      match -> hd match
    end).()
    |> (&EnumParser.set_name state, &1).()
  end

  @spec parse_properties(state, block) :: state
  defp parse_properties(state, enum_block) do
    Regex.scan(~r/(?<!enum\s)(?<=\s).+[^\)\}](?=\n)/, enum_block)
    |> (fn
      [] -> state
      properties ->
        properties
        |> Enum.reduce(state, &PlantUmlParser.EnumPropertyParser.parse_public_property(&2, hd(&1) |> String.trim))
    end).()
  end

end
