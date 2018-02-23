defmodule PlantUmlParser.ClassMethodParameter do
  alias PlantUmlParser.Property, as: Property
  alias PlantUmlParser.ClassMethod, as: ClassMethod

  @type state :: PlantUmlParser.state

  @spec set_accessibility(state, String.t) :: state
  def set_accessibility(state, accessibility),
    do: ClassMethod.update_parameter state, &Property.set_accessibility(&1, accessibility)

  @spec set_type(state, String.t) :: state
  def set_type(state, type), do: ClassMethod.update_parameter state, &Property.set_type(&1, type)

  @spec set_name(state, String.t) :: state
  def set_name(state, name), do: ClassMethod.update_parameter state, &Property.set_name(&1, name)

  @spec set_description(state, String.t) :: state
  def set_description(state, description), do: ClassMethod.update_parameter state, &Property.set_description(&1, description)
end
