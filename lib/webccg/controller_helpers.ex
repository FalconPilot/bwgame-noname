defmodule Webccg.ControllerHelpers do
  alias Webccg.User
  import Plug.Conn, only: [get_session: 2, assign: 3]
  import Phoenix.Controller, only: [put_flash: 3, render: 2, redirect: 2]

  # Default page rendering
  def display(conn, url) do
    conn
      |> assign_logged_off(:loginset, User.changeset(%User{}))
      |> render(url)
  end

  # Assign if admin
  def assign_admin(conn, key, value) do
    case get_session(conn, :current_user) do
      nil ->
        conn
      user ->
        if user.privilege >= 3 do
          assign(conn, key, value)
        else
          conn
        end
    end
  end

  # Assign if logged off
  def assign_logged_off(conn, key, value) do
    case get_session(conn, :current_user) do
      nil ->
        assign(conn, key, value)
      _user ->
        conn
    end
  end

  # Admin redirection
  def redirect_admin(conn, url) do
    conn
      |> put_flash(:error, "Vous devez être administrateur")
      |> redirect(to: url)
  end

end
