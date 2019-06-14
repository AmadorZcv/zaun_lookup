defmodule ZaunLookup.Matches do
  import Ecto.Query, warn: false
  alias ZaunLookup.Repo
  alias ZaunLookup.Players.Match
  alias ZaunLookup.Players

  @doc """
  Returns the list of matches.

  ## Examples

      iex> list_matches()
      [%Match{}, ...]

  """
  def list_matches do
    Repo.all(Match)
  end

  def list_matches_to_update(region) do
    Match
    |> order_by([m], fragment("?::time", m.updated_at))
    |> where([m], m.region == ^region.region)
    |> where([m], not m.fetched)
    |> limit(^region.requests)
    |> Repo.all()
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

  def create_matches_from_match_list(matches) do
    Enum.each(matches, &create_match_from_match_list(&1))
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
      season_id: match["season"],
      region: match["region"]
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
      match["participantIdentities"] |> Enum.take(5) |> Enum.map(&Players.user_id_from_match(&1))

    red_players =
      match["participantIdentities"] |> Enum.take(-5) |> Enum.map(&Players.user_id_from_match(&1))

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
