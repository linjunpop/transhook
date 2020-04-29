defmodule TranshookWeb.HookControllerTest do
  use TranshookWeb.ConnCase

  alias Transhook.Webhook

  @create_attrs %{dispatcher: %{}, endpoint: "some endpoint", responder: %{}, trans_template: "some trans_template"}
  @update_attrs %{dispatcher: %{}, endpoint: "some updated endpoint", responder: %{}, trans_template: "some updated trans_template"}
  @invalid_attrs %{dispatcher: nil, endpoint: nil, responder: nil, trans_template: nil}

  def fixture(:hook) do
    {:ok, hook} = Webhook.create_hook(@create_attrs)
    hook
  end

  describe "index" do
    test "lists all hooks", %{conn: conn} do
      conn = get(conn, Routes.hook_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Hooks"
    end
  end

  describe "new hook" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.hook_path(conn, :new))
      assert html_response(conn, 200) =~ "New Hook"
    end
  end

  describe "create hook" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.hook_path(conn, :create), hook: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.hook_path(conn, :show, id)

      conn = get(conn, Routes.hook_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Hook"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.hook_path(conn, :create), hook: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Hook"
    end
  end

  describe "edit hook" do
    setup [:create_hook]

    test "renders form for editing chosen hook", %{conn: conn, hook: hook} do
      conn = get(conn, Routes.hook_path(conn, :edit, hook))
      assert html_response(conn, 200) =~ "Edit Hook"
    end
  end

  describe "update hook" do
    setup [:create_hook]

    test "redirects when data is valid", %{conn: conn, hook: hook} do
      conn = put(conn, Routes.hook_path(conn, :update, hook), hook: @update_attrs)
      assert redirected_to(conn) == Routes.hook_path(conn, :show, hook)

      conn = get(conn, Routes.hook_path(conn, :show, hook))
      assert html_response(conn, 200) =~ "some updated endpoint"
    end

    test "renders errors when data is invalid", %{conn: conn, hook: hook} do
      conn = put(conn, Routes.hook_path(conn, :update, hook), hook: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Hook"
    end
  end

  describe "delete hook" do
    setup [:create_hook]

    test "deletes chosen hook", %{conn: conn, hook: hook} do
      conn = delete(conn, Routes.hook_path(conn, :delete, hook))
      assert redirected_to(conn) == Routes.hook_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.hook_path(conn, :show, hook))
      end
    end
  end

  defp create_hook(_) do
    hook = fixture(:hook)
    %{hook: hook}
  end
end
