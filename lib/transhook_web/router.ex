defmodule TranshookWeb.Router do
  use TranshookWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {TranshookWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TranshookWeb do
    pipe_through :browser

    # get "/", PageController, :index

    live "/", PageLive, :index

    # resources "/hooks", HookController

    live "/hooks", HookLive.Index, :index
    live "/hooks/new", HookLive.Index, :new
    live "/hooks/:id/edit", HookLive.Index, :edit

    live "/hooks/:id", HookLive.Show, :show
    live "/hooks/:id/show/edit", HookLive.Show, :edit
  end

  scope "/api", TranshookWeb.API, as: :api do
    pipe_through :api

    match(:*, "/hooks/:endpoint_id", HookController, :handle_hook)
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TranshookWeb.Telemetry
    end
  end
end
