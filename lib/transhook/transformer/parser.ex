defmodule Transhook.Transformer.Parser do
  alias Transhook.Transformer.JSONPathParser

  def parse(template, json_params) when is_binary(template) and is_map(json_params) do
    json_template = Jason.decode!(template)

    json_template
    |> Enum.map(&traverse(&1, json_params))
    |> Enum.into(%{})
    |> Jason.encode!(escape: :json)
  end

  def traverse({key, val}, json_params) when is_map(val) do
    result =
      val
      |> Enum.map(&traverse(&1, json_params))
      |> Enum.into(%{})

    {key, result}
  end

  def traverse({key, val}, json_params) when is_list(val) do
    result =
      val
      |> Enum.map(&traverse(&1, json_params))

    {key, result}
  end

  def traverse({key, string_with_json_path}, json_params) when is_binary(string_with_json_path) do
    {:ok, matches, _, _, _, _} = JSONPathParser.parse(string_with_json_path)

    result =
      matches
      |> Enum.reduce(string_with_json_path, fn %{
                                                 begin_mark: begin_mark,
                                                 selector: selector,
                                                 end_mark: end_mark
                                               },
                                               acc ->
        extracted_value = extract_value(selector, string_with_json_path, json_params)
        placeholder = "#{begin_mark}#{selector}#{end_mark}"

        String.replace(acc, placeholder, extracted_value)
      end)

    {key, result}
  end

  def traverse(map_value, json_params) when is_map(map_value) do
    map_value
    |> Enum.map(&traverse(&1, json_params))
    |> Enum.into(%{})
  end

  defp extract_value(nil, val, _json_params), do: val

  defp extract_value(json_path, _val, json_params) do
    result = Warpath.query(json_params, json_path)

    case result do
      {:ok, content_list} when is_list(content_list) ->
        content_list
        |> Enum.map_join("\n", fn value ->
          normalize_value(value)
        end)

      {:ok, other_value} ->
        normalize_value(other_value)
    end
  end

  defp normalize_value(v) when is_binary(v), do: v
  defp normalize_value(v) when is_integer(v), do: Integer.to_string(v)
  defp normalize_value(nil), do: ""
end
