defmodule HanoiWeb.PageControllerTest do
  use HanoiWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Hanoi"
  end
end
