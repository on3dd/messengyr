defmodule MessengyrWeb.Router do
  use MessengyrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MessengyrWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Guardian.Plug.Pipeline,
      module: Messengyr.Auth.Guardian,
      error_handler: Messengyr.Auth.ErrorHandler
  end

  pipeline :auth_session do
    plug Messengyr.Auth.Pipeline
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug Messengyr.Auth.Pipeline
  end

  scope "/", MessengyrWeb do
    pipe_through [:browser, :auth_session]

    get "/", PageController, :index
    get "/signup", PageController, :signup
    get "/login", PageController, :login
    get "/logout", PageController, :logout
    post "/signup", PageController, :create_user
    post "/login", PageController, :login_user

    get "/messages", ChatController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", MessengyrWeb do
    pipe_through :api

    resources "/users", UserController, only: [:show]
    resources "/rooms", RoomController
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
      live_dashboard "/dashboard", metrics: MessengyrWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
