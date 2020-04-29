defmodule TranshookWeb.API.HookController do
  use TranshookWeb, :controller

  alias Transhook.Webhook
  alias Transhook.Webhook.Hook
  alias Transhook.Transformer

  def handle_hook(conn, %{"endpoint_id" => endpoint_id} = params) do
    case Webhook.get_hook_by_endpoint_id(endpoint_id) do
      nil ->
        conn
        |> resp(404, "Not found")

      hook ->
        json = Jason.encode!(params)
        Transformer.transform(hook, json)

        responder = hook.responder

        conn
        |> put_resp_content_type(responder.content_type)
        |> resp(responder.status_code, responder.payload)
    end
  end
end
