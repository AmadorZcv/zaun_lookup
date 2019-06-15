defmodule ZaunLookupWeb.PageController do
  use ZaunLookupWeb, :controller
  alias ZaunLookup.{Matches, Players}
  alias Phoenix.LiveView

  def index(conn, _params) do
    conn
    |> LiveView.Controller.live_render(ZaunLookupWeb.PageLive, session: %{})
  end
end
