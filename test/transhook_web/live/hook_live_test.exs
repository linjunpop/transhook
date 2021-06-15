defmodule TranshookWeb.HookLiveTest do
  use TranshookWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Transhook.Webhook

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp fixture(:hook) do
    {:ok, hook} = Webhook.create_hook(@create_attrs)
    hook
  end

  defp create_hook(_) do
    hook = fixture(:hook)
    %{hook: hook}
  end

  describe "Index" do
    setup [:create_hook]

    test "lists all hooks", %{conn: conn, hook: hook} do
      {:ok, _index_live, html} = live(conn, Routes.admin_hook_index_path(conn, :index))

      assert html =~ "Listing Hooks"
      assert html =~ hook.name
    end

    test "saves new hook", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.admin_hook_index_path(conn, :index))

      assert index_live |> element("a", "New Hook") |> render_click() =~
               "New Hook"

      assert_patch(index_live, Routes.admin_hook_index_path(conn, :new))

      assert index_live
             |> form("#hook-form", hook: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#hook-form", hook: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_hook_index_path(conn, :index))

      assert html =~ "Hook created successfully"
      assert html =~ "some name"
    end

    test "updates hook in listing", %{conn: conn, hook: hook} do
      {:ok, index_live, _html} = live(conn, Routes.admin_hook_index_path(conn, :index))

      assert index_live |> element("#hook-#{hook.id} a", "Edit") |> render_click() =~
               "Edit Hook"

      assert_patch(index_live, Routes.admin_hook_index_path(conn, :edit, hook))

      assert index_live
             |> form("#hook-form", hook: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#hook-form", hook: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_hook_index_path(conn, :index))

      assert html =~ "Hook updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes hook in listing", %{conn: conn, hook: hook} do
      {:ok, index_live, _html} = live(conn, Routes.admin_hook_index_path(conn, :index))

      assert index_live |> element("#hook-#{hook.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#hook-#{hook.id}")
    end
  end

  describe "Show" do
    setup [:create_hook]

    test "displays hook", %{conn: conn, hook: hook} do
      {:ok, _show_live, html} = live(conn, Routes.admin_hook_show_path(conn, :show, hook))

      assert html =~ "Show Hook"
      assert html =~ hook.name
    end

    test "updates hook within modal", %{conn: conn, hook: hook} do
      {:ok, show_live, _html} = live(conn, Routes.admin_hook_show_path(conn, :show, hook))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Hook"

      assert_patch(show_live, Routes.admin_hook_show_path(conn, :edit, hook))

      assert show_live
             |> form("#hook-form", hook: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#hook-form", hook: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_hook_show_path(conn, :show, hook))

      assert html =~ "Hook updated successfully"
      assert html =~ "some updated name"
    end
  end
end
