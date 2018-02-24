defmodule PlantUmlParser.PropertyParser do
  alias CodeParserState.Property, as: Property

  @type property :: Property.property

  @spec parse_public_property(String.t) :: property
  def parse_public_property(property_block) do
    %Property{}
    |> Property.set_accessibility("public")
    |> parse_type(property_block)
    |> parse_name(property_block)
    |> parse_description(property_block)
  end

  @spec parse_private_property(String.t) :: property
  def parse_private_property(property_block) do
    %Property{}
    |> Property.set_accessibility("private")
    |> parse_type(property_block)
    |> parse_name(property_block)
    |> parse_description(property_block)
  end

  @spec parse_type(property, String.t) :: property
  defp parse_type(property, property_block) do
    Regex.run(~r/(?<=^)[<>\w]+/, property_block)
    |> (fn
      nil -> ""
      [] -> ""
      match -> hd match
    end).()
    |> (&Property.set_type(property, &1)).()
  end

  @spec parse_name(property, String.t) :: property
  defp parse_name(property, property_block) do
    Regex.run(~r/(?<=\s)\w+/, property_block)
    |> (fn
      nil -> ""
      [] -> ""
      match -> hd match
    end).()
    |> (&Property.set_name(property, &1)).()
  end

  @spec parse_description(property, String.t) :: property
  defp parse_description(property, property_block) do
    Regex.run(~r/(?<=\/\/).+/, property_block)
    |> (fn
      nil -> "TODO"
      [] -> "TODO"
      match -> hd(match) |> String.trim
    end).()
    |> (&Property.set_description property, &1).()
  end

end
