defmodule PlantUmlParser.ClassParser do
  alias CodeParserState.Class, as: Class

  @type state :: CodeParserState.state
  @type block :: String.t

  @spec parse_class(state, block) :: state
  def parse_class(state, class_block) do
    state
    |> parse_name(class_block)
    |> parse_description(class_block)
    |> parse_properties(class_block)
    |> parse_methods(class_block)
    |> parse_relations(class_block)
  end

  @spec parse_name(state, block) :: state
  defp parse_name(state, class_block) do
    Regex.run(~r/(?<=\s)(\.|\w)+/, class_block)
    |> (fn
      nil -> ""
      [] -> ""
      match -> hd match
    end).()
    |> (&Class.set_name state, &1).()
  end

  @spec parse_properties(state, block) :: state
  defp parse_properties(state, class_block) do
    state = Regex.scan(~r/(?<=\+).+[^\)](?=\n)/, class_block) # TODO methods with comments hit here
    |> (fn
      [] -> state
      properties -> properties |> Enum.reduce(state, &PlantUmlParser.ClassPropertyParser.parse_public_property(&2, hd &1))
    end).()
    Regex.scan(~r/(?<=\-).+[^\)](?=\n)/, class_block)
    |> (fn
      [] -> state
      properties -> properties |> Enum.reduce(state, &PlantUmlParser.ClassPropertyParser.parse_private_property(&2, hd &1))
    end).()
  end

  @spec parse_methods(state, block) :: state
  defp parse_methods(state, class_block) do
    state = Regex.scan(~r/(?<=\+).+\)(\s\/\/(.+))*(?=\n)/, class_block)
    |> (fn
      [] -> state
      properties -> properties |> Enum.reduce(state, &PlantUmlParser.ClassMethodParser.parse_public_method(&2, hd &1))
    end).()
    Regex.scan(~r/(?<=\-).+\)(\s\/\/(.+))*(?=\n)/, class_block)
    |> (fn
      [] -> state
      properties -> properties |> Enum.reduce(state, &PlantUmlParser.ClassMethodParser.parse_private_method(&2, hd &1))
    end).()
  end

  @spec parse_relations(state, block) :: state
  defp parse_relations(state, class_block) do
    Regex.run(~r/(?<=:\s)[\w,\s]+(?=\s\{)/, class_block)
    |> (fn
      [match] -> match |> String.split(", ")
      _ -> []
    end).()
    |> Enum.reduce(state, &Class.add_relation(&2, &1))
  end

  @spec parse_description(state, block) :: state
  defp parse_description(state, class_block) do
    Regex.run(~r/(?<=\/\/).+/, class_block)
    |> (fn
      [match] -> match |> String.trim
      _ -> "TODO"
    end).()
    |> (&Class.set_description state, &1).()
  end

end
