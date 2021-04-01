defmodule TranshookWeb.HookLive.Index do
  use TranshookWeb, :live_view

  alias Transhook.Webhook
  alias Transhook.Webhook.Hook

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :hooks, list_hooks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Hook")
    |> assign(:hook, Webhook.get_hook!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Hook")
    |> assign(:hook, %Hook{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Hooks")
    |> assign(:hook, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    hook = Webhook.get_hook!(id)
    {:ok, _} = Webhook.delete_hook(hook)

    {:noreply, assign(socket, :hooks, list_hooks())}
  end

  defp list_hooks do
    Webhook.list_hooks()
  end
end
