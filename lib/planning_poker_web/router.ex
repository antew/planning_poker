defmodule PlanningPokerWeb.Router do
  use PlanningPokerWeb, :router
  import Phoenix.LiveDashboard.Router
  import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {PlanningPokerWeb.LayoutView, :app}
    plug :put_root_layout, {PlanningPokerWeb.LayoutView, :app}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through [:browser, :admins_only]
    live_dashboard "/dashboard"
  end

  scope "/", PlanningPokerWeb do
    pipe_through :browser

    get "/", LandingController, :index

    live "/:id", PokerRoom
  end

  pipeline :admins_only do
    plug :basic_auth, 
      username: "admin", 
    password: Application.get_env(:planning_poker, :live_view_dashboard)[:password]
  end

end
