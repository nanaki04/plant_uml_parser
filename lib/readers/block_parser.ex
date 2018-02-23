defmodule PlantUmlParser.BlockParser do

  @type namespace_block :: String.t
  @type class_block :: String.t
  @type result :: %{optional(namespace_block) => [class_block]}
  @type parser_state :: %PlantUmlParser.BlockParser{
    global_classes: [String.t],
    global_interfaces: [String.t],
    global_enums: [String.t],
    current_block: [class_block],
    result: result
  }
  @type file :: String.t

  defstruct file: "",
    global_classes: [],
    global_interfaces: [],
    global_enums: [],
    current_block: [],
    result: %{}

  @spec parse(file) :: result
  def parse(file) do
    %PlantUmlParser.BlockParser{file: file}
    |> build_meta_data
    |> parse_next_block
    |> Map.fetch!(:result)
  end

  @spec parse_next_block(parser_state) :: parser_state
  defp parse_next_block(parser_state) do
    parse_next_block(parser_state, scan_first_inner_block(parser_state))
  end

  @spec parse_next_block(parser_state, String.t | nil) :: parser_state
  defp parse_next_block(parser_state, nil), do: parser_state

  defp parse_next_block(parser_state, block) do
    parser_state = parser_state
    |> assign_block(block)
    |> remove_first_inner_block
    parse_next_block(parser_state, scan_first_inner_block(parser_state))
  end

  @spec build_meta_data(parser_state) :: parser_state
  defp build_meta_data(parser_state) do
    parser_state
    |> scan_global_classes
    |> scan_global_interfaces
    |> scan_global_enums
    |> create_global_namespace
  end

  @spec assign_block(parser_state, String.t) :: parser_state
  defp assign_block(parser_state, block) do
    parser_state
    |> assign_namespace(block, is_namespace(block))
    |> assign_class(block, is_class(block))
    |> assign_interface(block, is_interface(block))
    |> assign_enum(block, is_enum(block))
  end

  @spec assign_namespace(parser_state, String.t, boolean) :: parser_state
  defp assign_namespace(parser_state, _, false), do: parser_state
  defp assign_namespace(parser_state, block, true) do
    parser_state
    |> Map.update!(:result, &Map.put(&1, block, parser_state.current_block))
    |> Map.put(:current_block, [])
  end

  @spec assign_class(parser_state, String.t, boolean) :: parser_state
  defp assign_class(parser_state, _, false), do: parser_state
  defp assign_class(parser_state, block, true) do
    case Enum.any?(parser_state.global_classes, fn global_class -> String.starts_with?(block, global_class) end) do
      true -> update_result_namespace(parser_state, "global", &[block | &1])
      _ -> Map.update!(parser_state, :current_block, &[block | &1])
    end
  end

  @spec assign_interface(parser_state, String.t, boolean) :: parser_state
  defp assign_interface(parser_state, _, false), do: parser_state
  defp assign_interface(parser_state, block, true) do
    case Enum.any?(parser_state.global_interfaces, fn global_interface -> String.starts_with?(block, global_interface) end) do
      true -> update_result_namespace(parser_state, "global", &[block | &1])
      _ -> Map.update!(parser_state, :current_block, &[block | &1])
    end
  end

  @spec assign_enum(parser_state, String.t, boolean) :: parser_state
  defp assign_enum(parser_state, _, false), do: parser_state
  defp assign_enum(parser_state, block, true) do
    case Enum.any?(parser_state.global_enums, fn global_enum -> String.starts_with?(block, global_enum) end) do
      true -> update_result_namespace(parser_state, "global", &[block | &1])
      _ -> Map.update!(parser_state, :current_block, &[block | &1])
    end
  end

  @spec update_result_namespace(parser_state, String.t, fun) :: parser_state
  defp update_result_namespace(parser_state, key, update) do
    Map.update!(parser_state, :result, fn result ->
      Map.update(result, key, [], update)
    end)
  end

  @spec is_namespace(String.t) :: boolean
  defp is_namespace(block) do
    Regex.match? ~r/(?<=^)namespace /, block
  end

  @spec is_class(String.t) :: boolean
  defp is_class(block) do
    Regex.match? ~r/(?<=^)class /, block
  end

  @spec is_interface(String.t) :: boolean
  defp is_interface(block) do
    Regex.match? ~r/(?<=^)interface /, block
  end

  @spec is_enum(String.t) :: boolean
  defp is_enum(block) do
    Regex.match? ~r/(?<=^)enum /, block
  end

  @spec scan_first_inner_block(parser_state) :: String.t | nil
  defp scan_first_inner_block(parser_state) do
    run parser_state, ~r/\w.+\{\n(\s+.+(?<!\s\{))+(?<!\})(\n|\s)\}/
  end

  @spec remove_first_inner_block(parser_state) :: parser_state
  defp remove_first_inner_block(parser_state) do
    Map.update!(parser_state, :file, fn file ->
      Regex.replace ~r/\w.+\{\n(\s+.+(?<!\s\{))+(?<!\})(\n|\s)\}/, file, "", global: false
    end)
  end

  @spec scan_global_classes(parser_state) :: parser_state
  defp scan_global_classes(parser_state) do
    scan parser_state, :global_classes, ~r/(?<=\n)class.+\{/
  end

  @spec scan_global_interfaces(parser_state) :: parser_state
  defp scan_global_interfaces(parser_state) do
    scan parser_state, :global_interfaces, ~r/(?<=\n)interface.+\{/
  end

  @spec scan_global_enums(parser_state) :: parser_state
  defp scan_global_enums(parser_state) do
    scan parser_state, :global_enums, ~r/(?<=\n)enum.+\{/
  end

  @spec create_global_namespace(parser_state) :: parser_state
  defp create_global_namespace(parser_state) do
    Map.update!(parser_state, :result, &Map.put(&1, "global", []))
  end

  @spec scan(parser_state, atom, %Regex{}) :: parser_state
  defp scan(parser_state, key, regex) do
    Regex.scan(regex, parser_state.file)
    |> (fn
      [] -> []
      matches -> hd matches
    end).()
    |> (&Map.put parser_state, key, &1).()
  end

  @spec run(parser_state, %Regex{}) :: String.t | nil
  defp run(parser_state, regex) do
    Regex.run(regex, parser_state.file)
    |> (fn
      nil -> nil
      [] -> nil
      matches when is_list(matches) -> hd matches
    end).()
  end
end
