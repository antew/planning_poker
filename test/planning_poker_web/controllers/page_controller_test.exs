defmodule PlanningPokerWeb.PageControllerTest do
  use PlanningPokerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/oiblz")
    assert html_response(conn, 200) =~ "Planning Poker"
  end
end
