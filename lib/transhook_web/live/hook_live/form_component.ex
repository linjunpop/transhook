defmodule TranshookWeb.HookLive.FormComponent do
  use TranshookWeb, :live_component

  alias Transhook.Webhook

  @impl true
  def update(%{hook: hook} = assigns, socket) do
    changeset = Webhook.change_hook(hook)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"hook" => hook_params}, socket) do
    changeset =
      socket.assigns.hook
      |> Webhook.change_hook(hook_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"hook" => hook_params}, socket) do
    save_hook(socket, socket.assigns.action, hook_params)
  end

  def handle_event("add-filter", _, socket) do
    existing_filters =
      Map.get(socket.assigns.changeset.changes, :hook_filters, socket.assigns.hook.hook_filters)

    filters =
      existing_filters
      |> Enum.concat([
        %Transhook.Webhook.HookFilter{
          query: "",
          operator: "is",
          value: ""
        }
      ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_embed(:hook_filters, filters)

    {:noreply, assign(socket, changeset: changeset)}
  end

  defp save_hook(socket, :edit, hook_params) do
    case Webhook.update_hook(socket.assigns.hook, hook_params) do
      {:ok, _hook} ->
        {:noreply,
         socket
         |> put_flash(:info, "Hook updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_hook(socket, :new, hook_params) do
    case Webhook.create_hook(hook_params) do
      {:ok, _hook} ->
        {:noreply,
         socket
         |> put_flash(:info, "Hook created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
