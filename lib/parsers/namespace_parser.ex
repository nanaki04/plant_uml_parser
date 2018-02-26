defmodule PlantUmlParser.NamespaceParser do
  alias CodeParserState.Namespace, as: Namespace
  alias CodeParserState.Class, as: Class
  alias CodeParserState.Interface, as: Interface
  alias CodeParserState.Enum, as: EnumState
  alias PlantUmlParser.ClassParser, as: ClassParser
  alias PlantUmlParser.InterfaceParser, as: InterfaceParser
  alias PlantUmlParser.EnumParser, as: EnumParser

  @type state :: CodeParserState.state
  @type block :: String.t

  @spec parse_namespace(state, {block, [block]}) :: state
  def parse_namespace(state, {namespace_block, child_blocks}) do
    {class_blocks, interface_blocks, enum_blocks} = sort_child_blocks(child_blocks)
    state
    |> CodeParserState.File.add_namespace(%Namespace{})
    |> parse_name(namespace_block)
    |> parse_classes(class_blocks)
    |> parse_interfaces(interface_blocks)
    |> parse_enums(enum_blocks)
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

  @spec parse_interfaces(state, [block]) :: state
  defp parse_interfaces(state, interface_blocks) do
    interface_blocks
    |> Enum.reduce(state, fn interface_block, state ->
      state
      |> Namespace.add_interface(%Interface{})
      |> InterfaceParser.parse_interface(interface_block)
    end)
  end

  @spec parse_enums(state, [block]) :: state
  defp parse_enums(state, enum_blocks) do
    enum_blocks
    |> Enum.reduce(state, fn enum_block, state ->
      state
      |> Namespace.add_enum(%EnumState{})
      |> EnumParser.parse_enum(enum_block)
    end)
  end

  @spec sort_child_blocks([block]) :: {[block], [block], [block]}
  defp sort_child_blocks(child_blocks) do
    child_blocks
    |> (&{
      filter_blocks(&1, fn
        "class " <> _ -> true
        _ -> false
      end),
      filter_blocks(&1, fn
        "interface " <> _ -> true
        _ -> false
      end),
      filter_blocks(&1, fn
        "enum " <> _ -> true
        _ -> false
      end)
    }).()
  end

  @spec filter_blocks([block], fun) :: [block]
  defp filter_blocks(child_blocks, filter) do
    child_blocks
    |> Enum.filter(&filter.(&1))
  end

end
