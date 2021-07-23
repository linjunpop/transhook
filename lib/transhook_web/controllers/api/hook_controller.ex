defmodule TranshookWeb.API.HookController do
  use TranshookWeb, :controller
  require Logger

  alias Transhook.Webhook
  alias Transhook.Transformer

  def handle_hook(conn, %{"endpoint_id" => endpoint_id} = params) do
    case Webhook.get_hook_by_endpoint_id(endpoint_id) do
      nil ->
        conn
        |> resp(404, "Not found")

      hook ->
        Logger.info(%{
          params: params,
          endpoint_id: endpoint_id,
          hook_id: hook.id,
          name: hook.name
        })

        Transformer.transform(hook, params)

        responder = hook.responder

        conn
        |> put_resp_content_type(responder.content_type)
        |> resp(responder.status_code, responder.payload)
    end
  end
end
