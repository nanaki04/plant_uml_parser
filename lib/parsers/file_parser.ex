defmodule PlantUmlParser.FileParser do
  alias CodeParserState.File, as: FileState
  alias PlantUmlParser.NamespaceParser, as: NamespaceParser

  @type state :: CodeParserState.state

  @spec parse_file(state, String.t) :: state
  def parse_file(state, path) do
    state
    |> CodeParserState.add_file(%CodeParserState.File{})
    |> FileState.set_name(path)
    |> parse_namespaces(path)
  end

  @spec read_file(String.t) :: String.t
  defp read_file(path) do
    File.read! path
  end

  @spec parse_namespaces(state, String.t) :: state
  defp parse_namespaces(state, path) do
    read_file(path)
    |> PlantUmlParser.BlockParser.parse
    |> Enum.reduce(state, &NamespaceParser.parse_namespace(&2, &1))
  end

end
