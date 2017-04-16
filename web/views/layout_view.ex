defmodule Webccg.LayoutView do
  use Webccg.Web, :view

  # Is user logged in ?
  def logged_in?(conn) do
    !!get_user conn
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
