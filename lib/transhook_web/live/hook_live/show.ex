defmodule TranshookWeb.HookLive.Show do
  use TranshookWeb, :live_view

  alias Transhook.Webhook

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

  defp page_title(:show), do: "Show Hook"
  defp page_title(:edit), do: "Edit Hook"
  defp page_title(:sample), do: "Sample"
end
