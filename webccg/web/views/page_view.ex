defmodule Webccg.PageView do
  use Webccg.Web, :view

  # Is user logged in ?
  def logged_in?(conn) do
    !!get_user conn
  end

  # Is user admin ?
  def is_admin?(conn) do
    if logged_in?(conn) do
      get_user(conn).privilege >= 3
    else
      false
    end
  end

  # Get current username
  def get_username(conn) do
    get_user(conn).username
  end

  # Get current user session
  def get_user(conn) do
    Plug.Conn.get_session(conn, :current_user)
  end
end
