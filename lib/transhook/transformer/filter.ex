defmodule Transhook.Transformer.Filter do
  alias Transhook.Webhook.HookFilter

  def should_continue?(hook_filters, params) do
    hook_filters
    |> Enum.any?(fn hook_filter ->
      check_hook(hook_filter, params)
    end)
  end

  defp check_hook(%HookFilter{query: query, operator: operator, value: value}, params) do
    json_query_value =
      case Warpath.query(params, query) do
        {:ok, []} ->
          ""

        {:ok, [v | _]} when is_binary(v) ->
          v

        {:ok, [v | _]} when is_integer(v) ->
          Integer.to_string(v)

        {:ok, v} when is_binary(v) ->
          v

        {:ok, v} when is_integer(v) ->
          Integer.to_string(v)

        _ ->
          ""
      end

    case operator do
      "is" ->
        json_query_value == value

      op ->
        raise RuntimeError, "Unsupported operator: #{op}"
    end
  end
end
