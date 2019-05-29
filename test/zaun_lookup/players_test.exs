defmodule ZaunLookup.PlayersTest do
  use ZaunLookup.DataCase

  alias ZaunLookup.Players

  describe "users" do
    alias ZaunLookup.Players.User

    @valid_attrs %{
      account_id: "some account_id",
      name: "some name",
      puuid: "some puuid",
      revision_date: 42,
      riot_id: "some riot_id"
    }
    @update_attrs %{
      account_id: "some updated account_id",
      name: "some updated name",
      puuid: "some updated puuid",
      revision_date: 43,
      riot_id: "some updated riot_id"
    }
    @invalid_attrs %{account_id: nil, name: nil, puuid: nil, revision_date: nil, riot_id: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Players.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Players.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Players.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Players.create_user(@valid_attrs)
      assert user.account_id == "some account_id"
      assert user.name == "some name"
      assert user.puuid == "some puuid"
      assert user.revision_date == 42
      assert user.riot_id == "some riot_id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Players.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Players.update_user(user, @update_attrs)
      assert user.account_id == "some updated account_id"
      assert user.name == "some updated name"
      assert user.puuid == "some updated puuid"
      assert user.revision_date == 43
      assert user.riot_id == "some updated riot_id"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Players.update_user(user, @invalid_attrs)
      assert user == Players.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Players.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Players.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Players.change_user(user)
    end
  end

  describe "matches" do
    alias ZaunLookup.Players.Match

    @valid_attrs %{
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

    def match_fixture(attrs \\ %{}) do
      {:ok, match} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Players.create_match()

      match
    end

    test "list_matches/0 returns all matches" do
      match = match_fixture()
      assert Players.list_matches() == [match]
    end

    test "get_match!/1 returns the match with given id" do
      match = match_fixture()
      assert Players.get_match!(match.id) == match
    end

    test "create_match/1 with valid data creates a match" do
      assert {:ok, %Match{} = match} = Players.create_match(@valid_attrs)
      assert match.game_creation == 42
      assert match.game_duration == 42
      assert match.game_id == 42
      assert match.game_mode == "some game_mode"
      assert match.game_type == "some game_type"
      assert match.game_version == "some game_version"
      assert match.map_id == 42
      assert match.platform_id == "some platform_id"
      assert match.queue_id == 42
      assert match.season_id == 42
      assert match.winning_team == "some winning_team"
    end

    test "create_match/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Players.create_match(@invalid_attrs)
    end

    test "update_match/2 with valid data updates the match" do
      match = match_fixture()
      assert {:ok, %Match{} = match} = Players.update_match(match, @update_attrs)
      assert match.game_creation == 43
      assert match.game_duration == 43
      assert match.game_id == 43
      assert match.game_mode == "some updated game_mode"
      assert match.game_type == "some updated game_type"
      assert match.game_version == "some updated game_version"
      assert match.map_id == 43
      assert match.platform_id == "some updated platform_id"
      assert match.queue_id == 43
      assert match.season_id == 43
      assert match.winning_team == "some updated winning_team"
    end

    test "update_match/2 with invalid data returns error changeset" do
      match = match_fixture()
      assert {:error, %Ecto.Changeset{}} = Players.update_match(match, @invalid_attrs)
      assert match == Players.get_match!(match.id)
    end

    test "delete_match/1 deletes the match" do
      match = match_fixture()
      assert {:ok, %Match{}} = Players.delete_match(match)
      assert_raise Ecto.NoResultsError, fn -> Players.get_match!(match.id) end
    end

    test "change_match/1 returns a match changeset" do
      match = match_fixture()
      assert %Ecto.Changeset{} = Players.change_match(match)
    end
  end
end
