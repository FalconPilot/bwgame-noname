defmodule Webccg.SessionController do
  use Webccg.Web, :controller

  # Initialize session
  def create(conn, %{"user" => user_params, "redirect" => url}) do
    user =
      if is_nil(user_params["username"]) do
          nil
      else
        Repo.get_by(User, username: user_params["username"])
      end
    conn
      |> login(user, user_params["password"], url)
  end

  # Login when user doesn't exist
  def login(conn, user, _password, url) when is_nil(user) do
    conn
      |> put_flash(:error, "Nom d'utilisateur inconnu")
      |> redirect(to: url)
  end

  # Login when user exist
  def login(conn, user, password, url) when is_map(user) do
    cond do
      Comeonin.Bcrypt.checkpw(password, user.encrypted_password) ->
        conn
          |> put_session(:current_user, user)
          |> put_flash(:info, "Bienvenue, #{user.username}")
          |> redirect(to: url)
      true ->
        conn
          |> put_flash(:error, "Mot de passe invalide")
          |> redirect(to: url)
    end
  end

  # Logout
  def logout(conn, _params) do
    conn
      |> delete_session(:current_user)
      |> redirect(to: "/")
  end
end
