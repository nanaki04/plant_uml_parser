defmodule PlantUmlParser.MethodParser do
  alias CodeParserState.Method, as: Method
  alias PlantUmlParser.PropertyParser, as: PropertyParser

  @type method :: Method.method

  @spec parse_public_method(String.t) :: method
  def parse_public_method(method_block) do
    %Method{}
    |> Method.set_accessibility("public")
    |> parse_type(method_block)
    |> parse_name(method_block)
    |> parse_parameters(method_block)
    |> parse_description(method_block)
  end

  @spec parse_private_method(String.t) :: method
  def parse_private_method(method_block) do
    %Method{}
    |> Method.set_accessibility("private")
    |> parse_type(method_block)
    |> parse_name(method_block)
    |> parse_parameters(method_block)
    |> parse_description(method_block)
  end

  @spec parse_type(method, String.t) :: method
  defp parse_type(method, method_block) do
    Regex.run(~r/(?<=^)\w+/, method_block)
    |> (fn
      nil -> ""
      [] -> ""
      match -> hd match
    end).()
    |> (&Method.set_type method, &1).()
  end

  @spec parse_name(method, String.t) :: method
  defp parse_name(method, method_block) do
    Regex.run(~r/(?<=\s)\w+/, method_block)
    |> (fn
      nil -> ""
      [] -> ""
      match -> hd match
    end).()
    |> (&Method.set_name method, &1).()
  end

  @spec parse_parameters(method, String.t) :: method
  defp parse_parameters(method, method_block) do
    Regex.run(~r/(?<=\().+(?=\))/, method_block)
    |> (fn
      nil -> ""
      [] -> ""
      match -> hd match
    end).()
    |> String.split(", ")
    |> Enum.reduce(method, &Method.add_parameter(&2, PropertyParser.parse_public_property(&1)))
  end

  @spec parse_description(method, String.t) :: method
  defp parse_description(method, method_block) do
    Regex.run(~r/(?<=\/\/).+/, method_block)
    |> (fn
      nil -> "TODO"
      [] -> "TODO"
      match -> hd(match) |> String.trim
    end).()
    |> (&Method.set_description method, &1).()
  end

end
