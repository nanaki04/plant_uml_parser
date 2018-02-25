defmodule PlantUmlParser.PropertyParser do
  alias CodeParserState.Property, as: Property

  @type property :: Property.property

  @spec parse_public_property(String.t) :: property
  def parse_public_property(property_block) do
    %Property{}
    |> parse_accessibility(property_block, "public")
    |> parse_type(property_block)
    |> parse_name(property_block)
    |> parse_description(property_block)
  end

  @spec parse_private_property(String.t) :: property
  def parse_private_property(property_block) do
    %Property{}
    |> parse_accessibility(property_block, "private")
    |> parse_type(property_block)
    |> parse_name(property_block)
    |> parse_description(property_block)
  end

  @spec parse_accessibility(property, String.t, String.t) :: property
  defp parse_accessibility(property, property_block, default) do
    Regex.run(~r/(?<=^)const(?=\s)/, property_block)
    |> (fn
      [const] -> default <> " " <> const
      _ -> default
    end).()
    |> (&Property.set_accessibility(property, &1)).()
  end

  @spec parse_type(property, String.t) :: property
  defp parse_type(property, property_block) do
    Regex.run(~r/(?<=^)[^(const)][<>\w]+(?=\s)(?!\s\/)|(?<=const\s)[<>\w]+(?=\s)(?!\s\/)/, property_block)
    |> (fn
      nil -> ""
      [] -> ""
      match -> hd match
    end).()
    |> (&Property.set_type(property, &1)).()
  end

  @spec parse_name(property, String.t) :: property
  defp parse_name(property, property_block) do
    Regex.run(~r/\w+(?=$)|\w+(?=\s\/)/, property_block)
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
