defmodule ZaunLookupWeb.Router do
  use ZaunLookupWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ZaunLookupWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources("/player", UserController)
    get "/matches", MatchController, :index
    get "/export", MatchController, :export
  end

  # Other scopes may use custom stacks.
  # scope "/api", ZaunLookupWeb do
  #   pipe_through :api
  # end
end
