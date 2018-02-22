defmodule PlantUmlParser.Namespace do
  alias PlantUmlParser, as: State
  alias PlantUmlParser.File, as: File

  @type namespace :: %PlantUmlParser.Namespace{
    name: String.t,
    classes: [PlantUmlParser.Class.class]
  }
  @type state :: State.state
  @type file :: File.file

  defstruct name: "",
    classes: [],
    interfaces: []

  @spec name(namespace) :: String.t
  def name(%{name: name}), do: name

  @spec classes(state) :: [PlantUmlParser.Class.class]
  def classes(%State{} = state), do: from_state state, &classes/1

  @spec classes(namespace) :: [PlantUmlParser.Class.class]
  def classes(%{classes: classes}), do: classes

  @spec set_name(state, String.t) :: state
  def set_name(%State{} = state, name) do
    state
    |> File.update_namespace(&set_name(&1, name))
  end

  @spec set_name(namespace, String.t) :: namespace
  def set_name(namespace, name) do
    namespace
    |> Map.put(:name, name)
  end

  @spec add_class(state, PlantUmlParser.Class.class) :: state
  def add_class(%State{} = state, class) do
    state
    |> File.update_namespace(&add_class(&1, class))
  end

  @spec add_class(namespace, PlantUmlParser.Class.class) :: namespace
  def add_class(namespace, class) do
    namespace
    |> Map.update!(:classes, &[class | &1])
  end

  @spec update_class(state, fun) :: state
  def update_class(%State{} = state, update) do
    state
    |> File.update_namespace(&update_class(&1, update))
  end

  @spec update_class(namespace, fun) :: namespace
  def update_class(namespace, update) do
    namespace
    |> Map.update!(:classes, fn
      [] -> []
      [head | tail] -> [update.(head) | tail]
    end)
  end

  @spec from_state(state, fun) :: term
  def from_state(state, delegate) do
    state
    |> PlantUmlParser.File.namespace
    |> delegate.()
  end

end
