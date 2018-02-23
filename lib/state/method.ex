defmodule PlantUmlParser.Method do
  alias PlantUmlParser.Property, as: Property

  @type method :: %PlantUmlParser.Method{
    accessibility: String.t,
    type: String.t,
    name: String.t,
    parameters: [Property.property],
    description: String.t
  }

  defstruct accessibility: "public",
    type: "void",
    name: "DoNothing",
    parameters: [],
    description: "TODO"

  @spec accessibility(method) :: String.t
  def accessibility(%{accessibility: accessibility}), do: accessibility

  @spec type(method) :: String.t
  def type(%{type: type}), do: type

  @spec name(method) :: String.t
  def name(%{name: name}), do: name

  @spec description(method) :: String.t
  def description(%{description: description}), do: description

  @spec parameters(method) :: [Property.property]
  def parameters(%{parameters: parameters}), do: parameters

  @spec set_accessibility(method, String.t) :: method
  def set_accessibility(method, accessibility) do
    method
    |> Map.put(:accessibility, accessibility)
  end

  @spec set_type(method, String.t) :: method
  def set_type(method, type) do
    method
    |> Map.put(:type, type)
  end

  @spec set_name(method, String.t) :: method
  def set_name(method, name) do
    method
    |> Map.put(:name, name)
  end

  @spec set_description(method, String.t) :: method
  def set_description(method, description) do
    method
    |> Map.put(:description, description)
  end

  @spec add_parameter(method, Property.property) :: method
  def add_parameter(method, parameter) do
    method
    |> Map.update!(:parameters, &[parameter | &1])
  end

  @spec update_parameter(method, fun) :: method
  def update_parameter(method, update) do
    method
    |> Map.update!(:parameters, fn
      [] -> []
      [head | tail] -> [update.(head) | tail]
    end)
  end
end
