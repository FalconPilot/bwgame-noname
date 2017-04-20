defmodule Webccg.UserController do
  use Webccg.Web, :controller

  # Update user
  def update(conn, %{"user" => params}) do
    case Integer.parse(params["id"]) do
      {id, _point} ->
        url = "/users/#{id}"
        case Repo.get_by(User, id: id) do
          nil ->
            conn
              |> put_flash(:error, "Utilisateur inconnu")
              |> redirect(to: url)
          user ->
            apply_params(conn, Enum.to_list(params), user, url)
        end
      _ ->
        conn
          |> put_flash(:error, "ID non fourni")
          |> redirect(to: "/users")
    end
  end

  # Avatar update
  # TODO
  defp apply_params(conn, [{"TODO_avatar", v}|t], user, url) do
    user =
      case HTTPoison.get(v, [], hackney: [pool: :default]) do
        {:ok, %HTTPoison.Response{status_code: 200}} ->
          Ecto.Changeset.change(user, avatar: v)

        {:ok, %HTTPoison.Response{status_code: code}} ->
          put_flash(conn, :error, "Avatar non-fonctionnel: Erreur #{code}")
          user

        {:error, %HTTPoison.Error{reason: _reason}} ->
          put_flash(conn, :error, "Erreur lors de l'obtention de l'avatar")
          user
      end
    apply_params(conn, t, user, url)
  end

  # ID update
  defp apply_params(conn, [{"id", _v}|t], user, url) do
    apply_params(conn, t, user, url)
  end

  # Update params
  defp apply_params(conn, [{k, v}|t], user, url) do
    atom = String.to_atom(k)
    value =
      case Integer.parse(v) do
        {int, _point} ->
          int
        _ ->
          v
      end
    user = Ecto.Changeset.change(user, %{atom => value})
    apply_params(conn, t, user, url)
  end

  # Empty param list
  defp apply_params(conn, [], user, url) do
    case Repo.update(user) do
      {:ok, new} ->
        conn
          |> put_session(:current_user, new)
          |> put_flash(:info, "Profil mis à jour")
          |> redirect(to: url)
      {:error, _} ->
        conn
          |> put_flash(:error, "Erreur de mise à jour")
          |> redirect(to: url)
    end
  end

end
