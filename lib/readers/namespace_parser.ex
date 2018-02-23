defmodule PlantUmlParser.NamespaceParser do
  alias PlantUmlParser.Namespace, as: Namespace

  def parse_namespace(state, {namespace_block, class_blocks}) do
    state
    |> PlantUmlParser.File.add_namespace(%Namespace{})
    |> parse_name(namespace_block)
    |> parse_classes(class_blocks)
  end

  def parse_name(state, namespace_block) do
    Regex.run(~r/(?<=\s)(\.|\w)+/, namespace_block)
    |> (fn
      nil -> ""
      [] -> ""
      match -> hd match
    end).()
    |> (&Namespace.set_name state, &1).()
  end

  def parse_classes(state, class_blocks) do
    state
  end

end
