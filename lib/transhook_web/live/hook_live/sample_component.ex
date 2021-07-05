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
end
