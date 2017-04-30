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

    post "/users/update", UserController, :update

    get "/cards", PageController, :cardlist
    get "/cards/:id", PageController, :card
    post "/cards/reorder", CardController, :reorder_ids

    post "/cards/new", CardController, :new
    post "/cards/obtain", CardController, :obtain
    post "/cards/give", CardController, :give_card
    delete "/cards/delete", CardController, :delete

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    post "/login", SessionController, :create
    get "/logout", SessionController, :logout

    # Admin pages only
    get "/admin", AdminController, :panel
    get "/admin/news", AdminController, :news
    post "/admin/news/create", AdminController, :create_news
    delete "/admin/news/delete", AdminController, :delete_news

  end

  # Other scopes may use custom stacks.
  # scope "/api", Webccg do
  #   pipe_through :api
  # end
end
