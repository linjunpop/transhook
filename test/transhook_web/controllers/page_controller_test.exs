defmodule TranshookWeb.PageControllerTest do
  use TranshookWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Transhook"
  end
end
