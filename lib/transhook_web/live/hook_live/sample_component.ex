defmodule TranshookWeb.HookLive.SampleComponent do
  use TranshookWeb, :live_component

  alias Transhook.Webhook
  alias Transhook.Transformer

  @impl true
  def update(%{hook: hook} = assigns, socket) do
    papertrail = Webhook.get_latest_papertrail(hook.id)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:latest_papertrail, papertrail)}
  end

  @impl true
  def handle_event(
        "try_sample",
        %{"hook-id" => hook_id, "papertrail-id" => papertrail_id},
        socket
      ) do
    # hook = Webhook.get_hook!(hook_id)
    # papertrail = Webhook.get_papertrail!(papertrail_id)

    Transformer.transform(socket.assigns.hook, socket.assigns.papertrail.request_data)

    {:noreply, socket}
  end
end
