defmodule Webccg.Router do
  use Webccg.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Webccg do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/users", PageController, :userlist
    get "/users/:id", PageController, :user

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    post "/login", SessionController, :create
    get "/logout", SessionController, :logout

  end

  # Other scopes may use custom stacks.
  # scope "/api", Webccg do
  #   pipe_through :api
  # end
end
