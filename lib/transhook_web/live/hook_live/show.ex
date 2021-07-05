defmodule TranshookWeb.HookLive.Show do
  use TranshookWeb, :live_view

  alias Transhook.Webhook
  alias Transhook.Transformer

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:hook, Webhook.get_hook!(id))}
  end

  @impl true
  def handle_event(
        "try_sample",
        %{"papertrail-id" => papertrail_id},
        socket
      ) do
    papertrail = Webhook.get_papertrail!(papertrail_id)

    Transformer.transform(socket.assigns.hook, papertrail.request_data)

    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Hook"
  defp page_title(:edit), do: "Edit Hook"
  defp page_title(:sample), do: "Sample"
end
