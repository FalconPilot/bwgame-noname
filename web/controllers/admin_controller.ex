defmodule Webccg.AdminController do
  use Webccg.Web, :controller

  # Show admin-only page
  def show(conn, %{"page" => page}) do
    if is_admin?(conn) do
      # Check if page exist
      if File.exists?("./web/templates/admin/#{page}.html.eex") do
        Webccg.PageController.display(conn, "#{page}.html")
      else
        conn
          |> put_flash(:error, "La page \"#{page}.html.eex\" n'existe pas")
          |> redirect(to: "/")
      end
    else
      Webccg.PageController.redirect_admin(conn, "/")
    end
  end

  # If no page has been provided
  def show(conn, _params) do
    if is_admin?(conn) do
      conn
        |> put_flash(:error, "Aucune page n'a été fournie")
        |> redirect(to: "/")
    else
      Webccg.PageController.redirect_admin(conn, "/")
    end
  end

  # Create a news
  def create_news(conn, %{"news" => news_params}) do
    if is_admin?(conn) do
      changeset = News.changeset(%News{}, news_params)
      case Repo.insert(changeset) do
        {:ok, _} ->
          conn
            |> put_flash(:info, "News créée avec succès")
            |> redirect(to: "/admin?page=news_panel")
        {:error, _} ->
          conn
            |> put_flash(:error, "Échec de la création")
            |> redirect(to: "/admin?page=news_panel")
      end
    else
      Webccg.PageController.redirect_admin(conn, "/")
    end
  end

  # Delete a news
  def delete_news(conn, %{"id" => id}) do
    if is_admin?(conn) do
      url = "/admin?page=news_panel"
      case Integer.parse(id) do
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
            |> put_flash(:error, "Argument invalide")
            |> redirect(to: url)
      end
    else
      Webccg.PageController.redirect_admin(conn, "/")
    end
  end

end
