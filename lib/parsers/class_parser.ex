defmodule PlantUmlParser.ClassParser do
  alias PlantUmlParser.Class, as: Class

  @type state :: PlantUmlParser.state
  @type block :: String.t

  def parse_class(state, class_block) do
    state
    |> parse_name(class_block)
    |> parse_properties(class_block)
    |> parse_methods(class_block)
  end

  defp parse_name(state, class_block) do
    Regex.run(~r/(?<=\s)(\.|\w)+/, class_block)
    |> (fn
      nil -> ""
      [] -> ""
      match -> hd match
    end).()
    |> (&Class.set_name state, &1).()
  end

  defp parse_properties(state, class_block) do
    state = Regex.scan(~r/(?<=\+).+[^\)](?=\n)/, class_block)
    |> (fn
      [] -> state
      properties -> hd(properties) |> Enum.reduce(state, &PlantUmlParser.PropertyParser.parse_public_property(&2, &1))
    end).()
    Regex.scan(~r/(?<=\-).+[^\)](?=\n)/, class_block)
    |> (fn
      [] -> state
      properties -> hd(properties) |> Enum.reduce(state, &PlantUmlParser.PropertyParser.parse_private_property(&2, &1))
    end).()
  end

  defp parse_methods(state, class_block) do
    state = Regex.scan(~r/(?<=\+).+(?=\n)/, class_block)
    |> (fn
      [] -> state
      properties -> hd(properties) |> Enum.reduce(state, &PlantUmlParser.MethodParser.parse_public_method(&2, &1))
    end).()
    Regex.scan(~r/(?<=\-).+(?=\n)/, class_block)
    |> (fn
      [] -> state
      properties -> hd(properties) |> Enum.reduce(state, &PlantUmlParser.MethodParser.parse_private_method(&2, &1))
    end).()
  end

end
