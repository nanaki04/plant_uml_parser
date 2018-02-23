defmodule PlantUmlParser.ClassProperty do
  alias PlantUmlParser.Property, as: Property
  alias PlantUmlParser, as: State
  alias PlantUmlParser.Class, as: Class

  @type state :: PlantUmlParser.state

  @spec set_accessibility(state, String.t) :: state
  def set_accessibility(%State{} = state, accessibility),
    do: Class.update_property state, &Property.set_accessibility(&1, accessibility)

  @spec set_type(state, String.t) :: state
  def set_type(%State{} = state, type), do: Class.update_property state, &Property.set_type(&1, type)

  @spec set_name(state, String.t) :: state
  def set_name(%State{} = state, name), do: Class.update_property state, &Property.set_name(&1, name)

  @spec set_description(state, String.t) :: state
  def set_description(%State{} = state, description),
    do: Class.update_property state, &Property.set_description(&1, description)
end
