defmodule Webccg.SessionController do
  use Webccg.Web, :controller
  alias Webccg.Password

  def create(conn, %{"user" => user_params}) do
    user = if is_nil(user_params["username"]),
      do: nil,
      else: Repo.get(User, username: user_params["username"])
    conn
      |> login(user, user_params["password"])
  end

  def login(conn, user, password) when is_nil(user) do
    conn
      |> put_flash(:error, "Username doesn't exist !")
      |> redirect(to: "/")
  end

  def login(conn, user, password) when is_map(user) do
    cond do
      Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
    end
  end
end
