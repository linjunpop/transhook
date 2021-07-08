defmodule Transhook.Transformer do
  require Logger

  alias Transhook.Transformer.Parser
  alias Transhook.Transformer.Filter

  alias Transhook.Webhook
  alias Transhook.Webhook.Hook

  @spec transform(Hook.t(), map()) :: any
  def transform(%Hook{} = hook, params) when is_struct(hook) and is_map(params) do
    dispatcher = hook.dispatcher

    case Webhook.create_papertrail(%{request_data: params, hook_id: hook.id}) do
      {:ok, papertrail} ->
        Logger.info(papertrail)

      {:error, err} ->
        Logger.warn(err)
    end

    if Filter.should_continue?(hook.hook_filters, params) do
      payload = Parser.parse(dispatcher.payload_template, params)

      Logger.info("=> Going to send payload to #{dispatcher.url}")
      Logger.info(payload)

      {:ok, response_json} =
        request(dispatcher.http_method, dispatcher.url, dispatcher.content_type, payload)

      Logger.info("Response #{response_json}")
    else
      Logger.warn("=> Stop as the filter check fails")
    end
  end

  def request(http_method, url, content_type, playload) do
    with {:ok, status_code, _headers, client_ref} when status_code in [200, 201] <-
           do_request(http_method, url, content_type, playload),
         {:ok, body} <- :hackney.body(client_ref),
         {:ok, json} <- Jason.decode(body) do
      {:ok, json}
    else
      {:ok, status_code, _headers, client_ref} ->
        {:ok, msg} = :hackney.body(client_ref)
        {:error, %{code: status_code, message: msg}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp do_request(http_method, url, content_type, playload) do
    request_headers = [
      {"content-type", content_type},
      {"accept", "application/json"}
    ]

    options = [
      {:pool, :transhook_hackney}
    ]

    :hackney.request(http_method, url, request_headers, playload, options)
  end
end
