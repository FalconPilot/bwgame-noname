defmodule Webccg.AdminController do
  use Webccg.Web, :controller

  # Display if user is admin
  def display_admin(conn, url, error_url \\ "/") do
    if is_admin?(conn) do
      display(conn, url)
    else
      redirect_admin(conn, error_url)
    end
  end

  # Admin panel
  def panel(conn, _params) do
    display_admin(conn, "admin_panel.html")
  end

  # News panel
  def news(conn, _params) do
    conn
      |> assign(:news, Repo.all(News))
      |> display_admin("news_panel.html")
  end

  # Create a news
  def create_news(conn, %{"news" => news_params}) do
    if is_admin?(conn) do
      changeset = News.changeset(%News{}, news_params)
      case Repo.insert(changeset) do
        {:ok, _} ->
          conn
            |> put_flash(:info, "News créée avec succès")
            |> redirect(to: "/admin/news")
        {:error, _} ->
          conn
            |> put_flash(:error, "Échec de la création")
            |> redirect(to: "/admin/news")
      end
    else
      redirect_admin(conn, "/")
    end
  end

  # Delete a news
  def delete_news(conn, %{"delete-news" => params}) do
    if is_admin?(conn) do
      url = "/admin/news"
      case Integer.parse(params["id"]) do
        {int, _point} ->
          query = from(n in News, [where: n.id == ^int])
          case Repo.delete_all(query) do
            {1, _} ->
              conn
                |> put_flash(:info, "News supprimée avec succès")
                |> redirect(to: url)
            {0, _} ->
              conn
                |> put_flash(:error, "Suppression de la news échouée")
                |> redirect(to: url)
          end
        _ ->
          conn
            |> put_flash(:error, "ID invalide")
            |> redirect(to: url)
      end
    else
      redirect_admin(conn, "/")
    end
  end

end
