defmodule PlanningPokerWeb.LandingController do
  use PlanningPokerWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/#{:rand.uniform(99999)}")
  end
end
