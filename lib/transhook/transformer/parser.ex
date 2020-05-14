defmodule Transhook.Transformer.Parser do
  def parse(template, json_params) when is_binary(template) and is_binary(json_params) do
    expression_pattern = ~r/{(?<json_path>.*)}/mU

    Regex.scan(expression_pattern, template, capture: :all)
    |> IO.inspect()
    |> extract_captures(template, json_params)
  end

  defp extract_captures([], template, _), do: template

  defp extract_captures(captures, template, json_params) do
    template_params =
      captures
      |> Enum.map(fn [pattern, value] ->
        {pattern, extract_value(value, json_params)}
      end)
      |> Enum.into(%{})
      |> Enum.uniq()

    template_params
    |> Enum.reduce(template, fn {pattern, value}, acc ->
      value =
        value
        |> String.replace("\n", "\\n")
        |> String.replace("\r", "\\r")

      String.replace(acc, pattern, value)
    end)
  end

  defp extract_value(value, json_params) do
    json_path = Jaxon.Path.parse!(value)

    result =
      json_params
      |> List.wrap()
      |> Jaxon.Stream.query(json_path)
      |> Enum.to_list()
      |> List.flatten()

    case result do
      [] ->
        ""

      [nil] ->
        ""

      [v | _] when is_binary(v) ->
        v

      [v | _] when is_integer(v) ->
        Integer.to_string(v)
    end
  end
end
