defmodule ZaunLookupWeb.PageController do
  use ZaunLookupWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
