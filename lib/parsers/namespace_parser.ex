defmodule PlantUmlParser.NamespaceParser do
  alias PlantUmlParser.Namespace, as: Namespace
  alias PlantUmlParser.Class, as: Class
  alias PlantUmlParser.ClassParser, as: ClassParser

  @type state :: PlantUmlParser.state
  @type block :: String.t

  @spec parse_namespace(state, {block, [block]}) :: state
  def parse_namespace(state, {namespace_block, class_blocks}) do
    state
    |> PlantUmlParser.File.add_namespace(%Namespace{})
    |> parse_name(namespace_block)
    |> parse_classes(class_blocks)
  end

  @spec parse_name(state, block) :: state
  defp parse_name(state, "global"), do: Namespace.set_name state, "global"
  defp parse_name(state, namespace_block) do
    Regex.run(~r/(?<=\s)(\.|\w)+/, namespace_block)
    |> (fn
      nil -> ""
      [] -> ""
      match -> hd match
    end).()
    |> (&Namespace.set_name state, &1).()
  end

  @spec parse_classes(state, [block]) :: state
  defp parse_classes(state, class_blocks) do
    class_blocks
    |> Enum.reduce(state, fn class_block, state ->
      state
      |> Namespace.add_class(%Class{})
      |> ClassParser.parse_class(class_block)
    end)
  end

end
