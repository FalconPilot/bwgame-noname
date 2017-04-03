defmodule Webccg.SessionController do
  use Webccg.Web, :controller
  alias Webccg.Password

  def login(conn, params) do
    redirect conn, "/"
  end
end
