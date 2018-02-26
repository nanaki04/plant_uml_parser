defmodule PlantUmlParser do
  @behaviour CodeParserState.Parser

  @type state :: CodeParserState.state
  @type file_path :: CodeParserState.Parser.file_path

  @impl(CodeParserState.Parser)
  def parse(file_path) do
    %CodeParserState{}
    |> PlantUmlParser.FileParser.parse_file(file_path)
  end
end
