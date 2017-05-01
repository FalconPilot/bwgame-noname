defmodule Webccg.RegistrationController do
  use Webccg.Web, :controller
  alias Webccg.Repo

  # New user page
  def new(conn, _params) do
    if !is_nil(get_session(conn, :current_user)) do
      conn
        |> put_flash(:error, "Impossible de s'inscrire en étant connecté")
        |> redirect(to: "/")
    else
      conn
        |> assign(:changeset, User.changeset(%User{}))
        |> display("register.html")
    end
  end

  # Create new user
  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, new_user} ->
        conn
          |> put_flash(:info, "Inscription réussie, #{new_user.username}")
          |> put_session(:current_user, new_user)
          |> redirect(to: "/")

      {:error, _} ->
        conn
          |> put_flash(:error, "Paramètres invalides !")
          |> assign(:changeset, changeset)
          |> display("register.html")
    end
  end

end
