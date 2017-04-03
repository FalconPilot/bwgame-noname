defmodule Webccg.RegistrationController do
  use Webccg.Web, :controller

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "register.html", changeset: changeset
  end

end
