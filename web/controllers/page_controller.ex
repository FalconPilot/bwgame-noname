defmodule Webccg.PageController do
  use Webccg.Web, :controller
  alias Webccg.Repo

  # Site index
  def index(conn, _params) do
    conn
      |> assign(:news, Repo.all(News))
      |> display("index.html")
  end

  # Userlist display
  def userlist(conn, _params) do
    query = from(u in User, order_by: u.username)
    conn
      |> assign(:userlist, Repo.all(query))
      |> display("userlist.html")
  end

  # Single user display
  def user(conn, %{"id" => user_id}) do
    case Integer.parse(user_id) do
      {id, _point} ->
        case Repo.get_by(User, id: id) do
          nil ->
            conn
              |> put_flash(:error, "Utilisateur inconnu")
              |> redirect(to: "/users")
          user ->
            cards = CardHelpers.get_cards(user.cards)
            conn
              |> assign(:pageuser, user)
              |> assign(:pagecards, cards)
              |> display("profile.html")
        end
      :error ->
        conn
          |> put_flash(:error, "URL invalide")
          |> redirect(to: "/users")
    end
  end

  # Single card display
  def card(conn, %{"id" => id}) do
    case Integer.parse(id) do
      {int, _point} ->
        case Repo.get_by(Card, display_id: int) do
          nil ->
            conn
              |> put_flash(:error, "Carte inconnue")
              |> redirect(to: "/cards")
          card ->
            conn
              |> assign(:pagecard, card)
              |> display("card.html")
        end
      _ ->
        conn
          |> put_flash(:error, "URL invalide")
          |> redirect(to: "/cards")
    end
  end

  # Cardlist display
  def cardlist(conn, _params) do
    query = from(c in Card, order_by: c.display_id)
    conn
      |> assign(:cardlist, Repo.all(query))
      |> assign_admin(:cardform, Card.changeset(%Card{}))
      |> display("cardlist.html")
  end

end
