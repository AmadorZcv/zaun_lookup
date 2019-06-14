defmodule ZaunLookup.Players do
  @moduledoc """
  The Players context.
  """

  import Ecto.Query, warn: false
  alias ZaunLookup.Repo

  alias ZaunLookup.Players.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def list_users_to_update(region) do
    User
    |> order_by([u], fragment("?::time", u.updated_at))
    |> where([u], u.region == ^region.region)
    |> where([u], is_nil(u.account_id))
    |> limit(^region.requests)
    |> Repo.all()
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def user_struct_from_match(user) do
    %{
      name: user["summonerName"],
      tier: user["rank"],
      account_id: user["accountId"],
      riot_id: user["summonerId"],
      last_updated: Time.utc_now() |> Time.truncate(:second),
      region: user["platformId"]
    }
  end

  def user_struct_from_league(user, region) do
    %{
      name: user["summonerName"],
      tier: user["rank"],
      points: user["leaguePoints"],
      riot_id: user["summonerId"],
      last_updated: Time.utc_now() |> Time.truncate(:second),
      region: region
    }
  end

  def user_struct_from_summoner(user, region) do
    %{
      name: user["name"],
      riot_id: user["id"],
      last_updated: Time.utc_now() |> Time.truncate(:second),
      region: region,
      account_id: user["accountId"],
      puuid: user["puuid"],
      begin_index: 0
    }
  end

  def create_user_from_league(user, region) do
    user_struct_from_league(user, region)
    |> create_user()
  end

  def update_user_from_league(updated, region, user) do
    updated_user = user_struct_from_league(updated, region)
    update_user(user, updated_user)
  end

  def update_user_from_summoner(updated, region, user) do
    updated_user = user_struct_from_summoner(updated, region)
    update_user(user, updated_user)
  end

  def user_id_from_match(user) do
    original_user =
      User
      |> where([u], u.riot_id == ^user["summonerId"])
      |> where([u], u.region == ^user["platformId"])
      |> Repo.one()

    case original_user do
      nil ->
        user_struct_from_match(user)
        |> create_user()

      original_user ->
        updated_user = user_struct_from_match(user)
        update_user(original_user, updated_user)
    end
  end

  alias ZaunLookup.Players.Match

  @doc """
  Returns the list of matches.

  ## Examples

      iex> list_matches()
      [%Match{}, ...]

  """
  def list_matches do
    Repo.all(Match)
  end

  @doc """
  Gets a single match.

  Raises `Ecto.NoResultsError` if the Match does not exist.

  ## Examples

      iex> get_match!(123)
      %Match{}

      iex> get_match!(456)
      ** (Ecto.NoResultsError)

  """
  def get_match!(id), do: Repo.get!(Match, id)

  @doc """
  Creates a match.

  ## Examples

      iex> create_match(%{field: value})
      {:ok, %Match{}}

      iex> create_match(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match(attrs \\ %{}) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  def create_match_from_match_list(match) do
    # "timestamp": 1558938649042,
    # "queue": 420,
    # "season": 13
    match_struct_from_match_list(match)
    |> create_match()
  end

  def match_struct_from_match_list(match) do
    %{
      game_id: match["gameId"],
      platform_id: match["platformId"],
      fetched: false,
      queue_id: match["queue"],
      season_id: match["season"]
    }
  end

  @doc """
  Updates a match.

  ## Examples

      iex> update_match(match, %{field: new_value})
      {:ok, %Match{}}

      iex> update_match(match, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_match(%Match{} = match, attrs) do
    match
    |> Match.changeset(attrs)
    |> Repo.update()
  end

  def update_match_from_match_detail(match) do
    updated_match = match_struct_from_match_detail(match)

    original_match =
      Match
      |> where([m], m.game_id == ^updated_match[:game_id])
      |> where([m], m.platform_id == ^updated_match[:platform_id])
      |> Repo.one()

    update_match(original_match, updated_match)
  end

  def match_struct_from_match_detail(match) do
    blue_players =
      match["participantIdentities"] |> Enum.take(5) |> Enum.map(&user_id_from_match(&1))

    red_players =
      match["participantIdentities"] |> Enum.take(-5) |> Enum.map(&user_id_from_match(&1))

    blue_team =
      match["teams"]
      |> Enum.at(0)
      |> Map.put_new("players", blue_players)
      |> Map.update!("win", &if(&1 == "win", do: true, else: false))

    red_team =
      match["teams"]
      |> Enum.at(1)
      |> Map.put_new("players", red_players)
      |> Map.update!("win", &if(&1 == "win", do: true, else: false))

    teams = %{blue_team: blue_team, red_team: red_team}

    %{
      game_id: match["gameId"],
      platform_id: match["platformId"],
      queue_id: match["queue"],
      season_id: match["season"],
      game_creation: match["gameCreation"],
      game_duration: match["gameDuration"],
      game_mode: match["gameMode"],
      game_type: match["gameMode"],
      game_version: match["gameVersion"],
      map_id: match["mapId"],
      fetched: true,
      teams: teams
    }
  end

  def teams_from_match_detail(teams) do
    blue_team = teams[:blue_team]
    red_team = teams[:red_team]

    [
      %{
        name: "blue",
        win: blue_team["win"],
        players: team_players_from_team(blue_team["players"])
      },
      %{
        name: "red",
        win: red_team["win"],
        players: team_players_from_team(red_team["players"])
      }
    ]
  end

  def team_players_from_team(players) do
    players
    |> Enum.map(fn player -> %{player_id: player["id"]} end)
  end

  @doc """
  Deletes a Match.

  ## Examples

      iex> delete_match(match)
      {:ok, %Match{}}

      iex> delete_match(match)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match(%Match{} = match) do
    Repo.delete(match)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match changes.

  ## Examples

      iex> change_match(match)
      %Ecto.Changeset{source: %Match{}}

  """
  def change_match(%Match{} = match) do
    Match.changeset(match, %{})
  end
end
