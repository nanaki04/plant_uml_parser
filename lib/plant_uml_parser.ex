defmodule PlantUmlParser do

  @type namespace :: PlantUmlParser.Namespace.namespace
  @type property :: PlantUmlParser.Property.property
  @type method :: PlantUmlParser.Method.method
  @type file :: PlantUmlParser.File.file
  @type state :: %PlantUmlParser{
    files: [file]
  }

  defstruct files: []

  @spec files(state) :: [PlantUmlParser.File.file]
  def files(%{files: files}), do: files

  @spec file(state) :: PlantUmlParser.File.file
  def file(%{files: []}), do: %PlantUmlParser.File{}
  def file(%{files: [file | _]}), do: file

  @spec add_file(state, file) :: state
  def add_file(state, file) do
    state
    |> Map.update!(:files, &[file | &1])
  end

  @spec update_file(state, fun) :: state
  def update_file(state, update) do
    state
    |> Map.update!(:files, fn
      [] -> []
      [head | tail] -> [update.(head) | tail]
    end)
  end
end
