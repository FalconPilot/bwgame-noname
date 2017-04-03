defmodule Webccg.PageController do
  use Webccg.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
