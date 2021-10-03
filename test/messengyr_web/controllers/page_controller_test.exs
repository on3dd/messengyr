defmodule MessengyrWeb.PageControllerTest do
  use MessengyrWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Messengyr!"
  end
end
