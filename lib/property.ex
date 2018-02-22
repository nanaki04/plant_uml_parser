defmodule PlantUmlParser.Property do

  @type property :: %PlantUmlParser.Property{
    accessibility: String.t,
    type: String.t,
    name: String.t,
    description: String.t
  }

  defstruct accessibility: "public",
    type: "var",
    name: "foo",
    description: "TODO"

  @spec accessibility(property) :: String.t
  def accessibility(%{accessibility: accessibility}), do: accessibility

  @spec type(property) :: String.t
  def type(%{type: type}), do: type

  @spec name(property) :: String.t
  def name(%{name: name}), do: name

  @spec description(property) :: String.t
  def description(%{description: description}), do: description

  @spec set_accessibility(property, String.t) :: property
  def set_accessibility(property, accessibility) do
    property
    |> Map.put(:accessibility, accessibility)
  end

  @spec set_type(property, String.t) :: property
  def set_type(property, type) do
    property
    |> Map.put(:type, type)
  end

  @spec set_name(property, String.t) :: property
  def set_name(property, name) do
    property
    |> Map.put(:name, name)
  end

  @spec set_description(property, String.t) :: property
  def set_description(property, description) do
    property
    |> Map.put(:description, description)
  end
end
