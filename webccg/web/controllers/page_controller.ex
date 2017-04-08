defmodule Webccg.PageController do
  alias Webccg.Repo
  use Webccg.Web, :controller

  # Default page rendering
  def display(conn, url) do
    conn
      |> assign(:loginset, User.changeset(%User{}))
      |> assign(:current_user, get_session(conn, :current_user))
      |> assign(:current_page, conn.request_path)
      |> render(url)
  end

  # Site index
  def index(conn, _params) do
    display(conn, "index.html")
  end

  # Userlist display
  def userlist(conn, _params) do
    conn
      |> assign(:userlist, Repo.all(User))
      |> display("userlist.html")
  end

  # Single user display
  def user(conn, %{"id" => user_id}) do
    case Integer.parse(user_id) do
      {id, _} ->
        case Repo.get_by(User, id: user_id) do
          nil ->
            conn
              |> put_flash(:error, "Utilisateur inconnu")
              |> redirect(to: "/users")
          user ->
            conn
              |> assign(:pageuser, user)
              |> display("user.html")
        end
      :error ->
        conn
          |> put_flash(:error, "URL invalide")
          |> redirect(to: "/users")
    end
  end

  # Cardlist display
  def cardlist(conn, _params) do
    conn
      |> assign(:cardlist, Repo.all(Card))
      |> display("cardlist.html")
  end
end
