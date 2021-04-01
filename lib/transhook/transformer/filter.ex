defmodule Transhook.Transformer.Filter do
  alias Transhook.Webhook.HookFilter

  def should_continue?(hook_filters, params) do
    hook_filters
    |> Enum.reduce_while(true, fn hook_filter, _acc ->
      if query_matched?(hook_filter, params) do
        {:cont, true}
      else
        {:halt, false}
      end
    end)
  end

  defp query_matched?(%HookFilter{query: query, operator: operator, value: value}, params) do
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
