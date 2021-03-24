defmodule Transhook.Transformer.Parser do
  def parse(template, json_params) when is_binary(template) and is_map(json_params) do
    expression_pattern = ~r/{(?<json_path>.*)}/mU

    Regex.scan(expression_pattern, template, capture: :all)
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

  defp extract_value(json_path, json_params) do
    result = Warpath.query(json_params, json_path)

    case result do
      {:ok, []} ->
        ""

      {:ok, [v | _]} when is_binary(v) ->
        v

      {:ok, [v | _]} when is_integer(v) ->
        Integer.to_string(v)

      {:ok, v} when is_binary(v)->
        v

      _ ->
        ""
    end
  end
end
