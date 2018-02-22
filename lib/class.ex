defmodule PlantUmlParser.Class do
  alias PlantUmlParser, as: State
  alias PlantUmlParser.Namespace, as: Namespace

  @type class :: %PlantUmlParser.Class{
    name: String.t,
    properties: [PlantUmlParser.Property.property],
    methods: [PlantUmlParser.Method.method]
  }
  @type state :: State.state
  @type namespace :: Namespace.namespace

  defstruct name: "",
    properties: [],
    methods: []

  @spec name(state) :: String.t
  def name(%State{} = state), do: from_state state, &name/1

  @spec name(class) :: String.t
  def name(%{name: name}), do: name

  @spec properties(state) :: [PlantUmlParser.Property.property]
  def properties(%State{} = state), do: from_state state, &properties/1

  @spec properties(class) :: [PlantUmlParser.Property.property]
  def properties(%{properties: properties}), do: properties

  @spec methods(state) :: [PlantUmlParser.Method.method]
  def methods(%State{} = state), do: from_state state, &methods/1

  @spec methods(class) :: [PlantUmlParser.Method.method]
  def methods(%{methods: methods}), do: methods

  @spec set_name(state, String.t) :: state
  def set_name(%State{} = state, name), do: Namespace.update_class(state, &set_name(&1, name))

  @spec set_name(class, String.t) :: class
  def set_name(class, name) do
    class
    |> Map.put(:name, name)
  end

  @spec add_property(state, PlantUmlParser.Property.property) :: state
  def add_property(%State{} = state, property), do: Namespace.update_class(state, &add_property(&1, property))

  @spec add_property(class, PlantUmlParser.Property.property) :: class
  def add_property(class, property) do
    class
    |> Map.update!(:properties, &[property | &1])
  end

  @spec update_property(state, fun) :: state
  def update_property(%State{} = state, update), do: Namespace.update_class(state, &update_property(&1, update))

  @spec update_property(class, fun) :: class
  def update_property(class, update) do
    class
    |> Map.update!(:properties, fn
      [] -> []
      [head | tail] -> [update.(head) | tail]
    end)
  end

  @spec add_method(state, PlantUmlParser.Method.method) :: state
  def add_method(%State{} = state, method), do: Namespace.update_class(state, &add_method(&1, method))

  @spec add_method(class, PlantUmlParser.Method.method) :: class
  def add_method(class, method) do
    class
    |> Map.update!(:methods, &[method | &1])
  end

  @spec update_method(state, fun) :: state
  def update_method(%State{} = state, update), do: Namespace.update_class(state, &update_method(&1, update))

  @spec update_method(class, fun) :: class
  def update_method(class, update) do
    class
    |> Map.update!(:methods, fn
      [] -> []
      [head | tail] -> [update.(head) | tail]
    end)
  end

  @spec from_state(state, fun) :: term
  defp from_state(state, delegate) do
    state
    |> Namespace.classes
    |> hd
    |> delegate.()
  end
end
