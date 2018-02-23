defmodule PlantUmlParser.File do
  alias PlantUmlParser, as: State

  @type file :: %PlantUmlParser.File{
    name: String.t,
    namespaces: [PlantUmlParser.Namespace.namespace]
  }
  @type state :: State.state

  defstruct name: "",
    namespaces: []

  @spec namespaces(file) :: [PlantUmlParser.Namespace.namespace]
  def namespaces(%{namespaces: namespaces}), do: namespaces

  @spec namespace(state) :: PlantUmlParser.Namespace.namespace
  def namespace(%State{} = state), do: State.file(state) |> namespace

  @spec namespace(file) :: PlantUmlParser.Namespace.namespace
  def namespace(file), do: hd(namespaces(file))

  @spec add_namespace(state, PlantUmlParser.Namespace.namespace) :: state
  def add_namespace(%State{} = state, namespace) do
    state
    |> State.update_file(&add_namespace(&1, namespace))
  end

  @spec add_namespace(file, PlantUmlParser.Namespace.namespace) :: file
  def add_namespace(file, namespace) do
    file
    |> Map.put(:namespaces, namespace)
  end

  @spec update_namespace(state, fun) :: state
  def update_namespace(%State{} = state, update) do
    state
    |> State.update_file(&update_namespace(&1, update))
  end

  @spec update_namespace(file, fun) :: file
  def update_namespace(file, update) do
    file
    |> Map.update!(:namespaces, fn
      [] -> []
      [head | tail] -> [update.(head) | tail]
    end)
  end

  @spec name(file) :: String.t
  def name(%{name: name}), do: name

  @spec set_name(state, String.t) :: state
  def set_name(%State{} = state, name) do
    state
    |> State.update_file(&set_name(&1, name))
  end

  @spec set_name(file, String.t) :: file
  def set_name(file, name) do
    file
    |> Map.put(:name, name)
  end
end
