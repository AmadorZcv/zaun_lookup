defmodule ZaunLookupWeb.MatchControllerTest do
  use ZaunLookupWeb.ConnCase

  alias ZaunLookup.Players

  @create_attrs %{
    game_creation: 42,
    game_duration: 42,
    game_id: 42,
    game_mode: "some game_mode",
    game_type: "some game_type",
    game_version: "some game_version",
    map_id: 42,
    platform_id: "some platform_id",
    queue_id: 42,
    season_id: 42,
    winning_team: "some winning_team"
  }
  @update_attrs %{
    game_creation: 43,
    game_duration: 43,
    game_id: 43,
    game_mode: "some updated game_mode",
    game_type: "some updated game_type",
    game_version: "some updated game_version",
    map_id: 43,
    platform_id: "some updated platform_id",
    queue_id: 43,
    season_id: 43,
    winning_team: "some updated winning_team"
  }
  @invalid_attrs %{
    game_creation: nil,
    game_duration: nil,
    game_id: nil,
    game_mode: nil,
    game_type: nil,
    game_version: nil,
    map_id: nil,
    platform_id: nil,
    queue_id: nil,
    season_id: nil,
    winning_team: nil
  }

  def fixture(:match) do
    {:ok, match} = Players.create_match(@create_attrs)
    match
  end

  describe "index" do
    test "lists all matches", %{conn: conn} do
      conn = get(conn, Routes.match_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Matches"
    end
  end

  describe "new match" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.match_path(conn, :new))
      assert html_response(conn, 200) =~ "New Match"
    end
  end

  describe "create match" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.match_path(conn, :create), match: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.match_path(conn, :show, id)

      conn = get(conn, Routes.match_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Match"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.match_path(conn, :create), match: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Match"
    end
  end

  describe "edit match" do
    setup [:create_match]

    test "renders form for editing chosen match", %{conn: conn, match: match} do
      conn = get(conn, Routes.match_path(conn, :edit, match))
      assert html_response(conn, 200) =~ "Edit Match"
    end
  end

  describe "update match" do
    setup [:create_match]

    test "redirects when data is valid", %{conn: conn, match: match} do
      conn = put(conn, Routes.match_path(conn, :update, match), match: @update_attrs)
      assert redirected_to(conn) == Routes.match_path(conn, :show, match)

      conn = get(conn, Routes.match_path(conn, :show, match))
      assert html_response(conn, 200) =~ "some updated game_mode"
    end

    test "renders errors when data is invalid", %{conn: conn, match: match} do
      conn = put(conn, Routes.match_path(conn, :update, match), match: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Match"
    end
  end

  describe "delete match" do
    setup [:create_match]

    test "deletes chosen match", %{conn: conn, match: match} do
      conn = delete(conn, Routes.match_path(conn, :delete, match))
      assert redirected_to(conn) == Routes.match_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.match_path(conn, :show, match))
      end
    end
  end

  defp create_match(_) do
    match = fixture(:match)
    {:ok, match: match}
  end
end
