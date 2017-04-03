defmodule Webccg.PageController do
  use Webccg.Web, :controller

  def index(conn, _params) do
    conn
      |> assign(:loginset, User.changeset(%User{}))
      |> render("index.html")
  end
end
