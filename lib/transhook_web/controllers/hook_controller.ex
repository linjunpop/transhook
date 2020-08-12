defmodule TranshookWeb.HookController do
  use TranshookWeb, :controller

  alias Transhook.Webhook
  alias Transhook.Webhook.Hook

  def index(conn, _params) do
    hooks = Webhook.list_hooks()

    render(conn, "index.html", hooks: hooks)
  end

  def new(conn, _params) do
    changeset = Webhook.change_hook(%Hook{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"hook" => hook_params}) do
    case Webhook.create_hook(hook_params) do
      {:ok, hook} ->
        conn
        |> put_flash(:info, "Hook created successfully.")
        |> redirect(to: Routes.hook_path(conn, :show, hook))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    hook = Webhook.get_hook!(id)
    render(conn, "show.html", hook: hook)
  end

  def edit(conn, %{"id" => id}) do
    hook = Webhook.get_hook!(id)
    changeset = Webhook.change_hook(hook)
    render(conn, "edit.html", hook: hook, changeset: changeset)
  end

  def update(conn, %{"id" => id, "hook" => hook_params}) do
    hook = Webhook.get_hook!(id)

    case Webhook.update_hook(hook, hook_params) do
      {:ok, hook} ->
        conn
        |> put_flash(:info, "Hook updated successfully.")
        |> redirect(to: Routes.hook_path(conn, :show, hook))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", hook: hook, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    hook = Webhook.get_hook!(id)
    {:ok, _hook} = Webhook.delete_hook(hook)

    conn
    |> put_flash(:info, "Hook deleted successfully.")
    |> redirect(to: Routes.hook_path(conn, :index))
  end
end
