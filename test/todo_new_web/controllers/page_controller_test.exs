defmodule TodoNewWeb.PageControllerTest do
  use TodoNewWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix To-Do!"
  end
end
