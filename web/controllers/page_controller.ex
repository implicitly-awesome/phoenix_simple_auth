defmodule SimpleAuth.PageController do
  use SimpleAuth.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
