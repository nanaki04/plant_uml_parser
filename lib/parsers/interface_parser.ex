defmodule PlantUmlParser.InterfaceParser do
  alias CodeParserState.Interface, as: Interface

  @type state :: CodeParserState.state
  @type block :: String.t

  @spec parse_interface(state, block) :: state
  def parse_interface(state, interface_block) do
    state
    |> parse_name(interface_block)
    |> parse_properties(interface_block)
    |> parse_methods(interface_block)
    |> parse_relations(interface_block)
  end

  @spec parse_name(state, block) :: state
  defp parse_name(state, interface_block) do
    Regex.run(~r/(?<=\s)(\.|\w)+/, interface_block)
    |> (fn
      nil -> ""
      [] -> ""
      match -> hd match
    end).()
    |> (&Interface.set_name state, &1).()
  end

  @spec parse_properties(state, block) :: state
  defp parse_properties(state, interface_block) do
    Regex.scan(~r/(?<=\+).+[^\)](?=\n)/, interface_block)
    |> (fn
      [] -> state
      properties -> hd(properties) |> Enum.reduce(state, &PlantUmlParser.InterfacePropertyParser.parse_public_property(&2, &1))
    end).()
  end

  @spec parse_methods(state, block) :: state
  defp parse_methods(state, interface_block) do
    state = Regex.scan(~r/(?<=\+).+\)(\s\/\/(.+))*(?=\n)/, interface_block)
    |> (fn
      [] -> state
      properties -> properties |> Enum.reduce(state, &PlantUmlParser.InterfaceMethodParser.parse_public_method(&2, hd &1))
    end).()
    Regex.scan(~r/(?<=\-).+\)(\s\/\/(.+))*(?=\n)/, interface_block)
    |> (fn
      [] -> state
      properties -> properties |> Enum.reduce(state, &PlantUmlParser.InterfaceMethodParser.parse_private_method(&2, hd &1))
    end).()
  end

  @spec parse_relations(state, block) :: state
  defp parse_relations(state, interface_block) do
    Regex.run(~r/(?<=:\s)[\w,\s]+(?=\s\{)/, interface_block)
    |> (fn
      [match] -> match |> String.split(", ")
      _ -> []
    end).()
    |> Enum.reduce(state, &Interface.add_relation(&2, &1))
  end

end
