defmodule PlantUmlParser do
  @behaviour CodeParserState.Parser

  @type state :: CodeParserState.state
  @type file_path :: CodeParserState.Parser.file_path

  @impl(CodeParserState.Parser)
  def parse(_file_path) do
    %CodeParserState{}
  end
end
