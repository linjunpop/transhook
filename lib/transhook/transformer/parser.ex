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
      # FIXME: very ugly one
      value =
        value
        |> String.replace("\n", "\\n")
        |> String.replace("\r", "\\r")
        |> String.replace("\t", "\\t")

      String.replace(acc, pattern, value)
    end)
  end

  defp extract_value(json_path, json_params) do
    result = Warpath.query(json_params, json_path)

    case result do
      {:ok, content_list} when is_list(content_list) ->
        content_list
        |> Enum.map(fn value ->
          normalize_value(value)
        end)
        |> Enum.join("\n")

      {:ok, other_value} ->
        normalize_value(other_value)
    end
  end

  defp normalize_value(v) when is_binary(v), do: v
  defp normalize_value(v) when is_integer(v), do: Integer.to_string(v)
  defp normalize_value(nil), do: ""
end
