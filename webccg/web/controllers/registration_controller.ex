defmodule Webccg.RegistrationController do
  use Webccg.Web, :controller
  alias Webccg.Password

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "register.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    if changeset.valid? do
      new_user = Password.generate_and_store(changeset)
      conn
        |> put_session(:current_user, new_user)
        |> redirect(to: "/")
    else
      render conn, "register.html", changeset: changeset
    end
  end

end
