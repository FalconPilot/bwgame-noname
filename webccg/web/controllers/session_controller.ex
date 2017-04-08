defmodule Webccg.SessionController do
  use Webccg.Web, :controller
  alias Webccg.Password

  # Initialize session
  def create(conn, %{"user" => user_params}) do
    user =
      if is_nil(user_params["username"]) do
          nil
      else
        Repo.get_by(User, username: user_params["username"])
      end
    conn
      |> login(user, user_params["password"])
  end

  # Login when user doesn't exist
  def login(conn, user, _password) when is_nil(user) do
    conn
      |> put_flash(:error, "Nom d'utilisateur inconnu")
      |> redirect(to: page_path(conn, :index))
  end

  # Login when user exist
  def login(conn, user, password) when is_map(user) do
    cond do
      Comeonin.Bcrypt.checkpw(password, user.encrypted_password) ->
        conn
          |> put_session(:current_user, user)
          |> put_flash(:info, "Bienvenue, #{user.username}")
          |> redirect(to: "/")
      true ->
        conn
          |> put_flash(:error, "Mot de passe invalide")
          |> redirect(to: "/")
    end
  end

  # Logout
  def logout(conn, _params) do
    conn
      |> delete_session(:current_user)
      |> redirect(to: "/")
  end
end
