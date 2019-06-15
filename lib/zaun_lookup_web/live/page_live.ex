defmodule ZaunLookupWeb.PageLive do
  use Phoenix.LiveView
  alias ZaunLookup.{Matches, Players}
  alias ZaunLookupWeb.PageView

  def mount(_session, socket) do
    if connected?(socket), do: Matches.subscribe()
    if connected?(socket), do: Players.subscribe()

    {:ok, fetch(socket)}
  end

  defp fetch(socket) do
    matches_number = Matches.count_matches()
    matches_update_number = Matches.count_matches_to_update()
    players_number = Players.count_players()

    assign(socket, %{
      matches: matches_number,
      matches_update: matches_update_number,
      players: players_number
    })
  end

  def handle_info({Players, [:player, :created], _}, socket) do
    players_number = Players.count_players()
    {:noreply, assign(socket, players: players_number)}
  end

  def handle_info({Players, [:player, :updated], _}, socket) do
    players_number = Players.count_players()
    {:noreply, assign(socket, players: players_number)}
  end

  def handle_info({Matches, [:match, :created], _}, socket) do
    matches_update = Matches.count_matches_to_update()
    {:noreply, assign(socket, matches_update: matches_update)}
  end

  def handle_info({Matches, [:match, :updated], _}, socket) do
    matches = Matches.count_matches()
    matches_update = Matches.count_matches_to_update()
    {:noreply, assign(socket, matches: matches, matches_update: matches_update)}
  end

  def render(assigns), do: PageView.render("index.html", assigns)
end
