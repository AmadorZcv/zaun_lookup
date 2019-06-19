defmodule ZaunLookup.MatchExporter do
  alias ZaunLookup.Repo
  @columns ~w(
  id
  game_duration
  season_id
  queue_id
  winning_team
  team_1_name
  team_1_win
  team_1_player_1_champion_id
  team_1_player_1_spell_1
  team_1_player_1_spell_2
  team_1_player_2_champion_id
  team_1_player_2_spell_1
  team_1_player_2_spell_2
  team_1_player_3_champion_id
  team_1_player_3_spell_1
  team_1_player_3_spell_2
  team_1_player_4_champion_id
  team_1_player_4_spell_1
  team_1_player_4_spell_2
  team_1_player_5_champion_id
  team_1_player_5_spell_1
  team_1_player_5_spell_2
  team_2_name
  team_2_win
  team_2_player_1_champion_id
  team_2_player_1_spell_1
  team_2_player_1_spell_2
  team_2_player_2_champion_id
  team_2_player_2_spell_1
  team_2_player_2_spell_2
  team_2_player_3_champion_id
  team_2_player_3_spell_1
  team_2_player_3_spell_2
  team_2_player_4_champion_id
  team_2_player_4_spell_1
  team_2_player_4_spell_2
  team_2_player_5_champion_id
  team_2_player_5_spell_1
  team_2_player_5_spell_2
  )a

  def export(query) do
    path = "/tmp/matches2.csv"

    Repo.transaction(fn ->
      query
      |> Repo.stream(max_rows: 100, timeout: :infinity)
      |> Stream.map(&parse_line/1)
      |> CSV.encode()
      |> Enum.into(File.stream!(path, [:write, :utf8]))
    end)
  end

  def get_team_player(team, index) do
    Enum.at(team.team_players, index)
  end

  defp parse_line(match) do
    IO.inspect("AQUI")

    full_match =
      Repo.preload(match, [:teams])
      |> Repo.preload(teams: [:team_players])

    team_1 = Enum.at(full_match.teams, 0)
    team_2 = Enum.at(full_match.teams, 1)

    map = %{
      id: full_match.id,
      game_duration: full_match.game_duration,
      season_id: full_match.season_id,
      queue_id: full_match.queue_id,
      winning_team: full_match.winning_team,
      team_1_name: team_1.name,
      team_1_win: team_1.win,
      team_1_player_1_champion_id: get_team_player(team_1, 0).champion_id,
      team_1_player_1_spell_1: get_team_player(team_1, 0).spell_1,
      team_1_player_1_spell_2: get_team_player(team_1, 0).spell_2,
      team_1_player_2_champion_id: get_team_player(team_1, 1).champion_id,
      team_1_player_2_spell_1: get_team_player(team_1, 1).spell_1,
      team_1_player_2_spell_2: get_team_player(team_1, 1).spell_1,
      team_1_player_3_champion_id: get_team_player(team_1, 2).champion_id,
      team_1_player_3_spell_1: get_team_player(team_1, 2).spell_1,
      team_1_player_3_spell_2: get_team_player(team_1, 2).spell_1,
      team_1_player_4_champion_id: get_team_player(team_1, 3).champion_id,
      team_1_player_4_spell_1: get_team_player(team_1, 3).spell_1,
      team_1_player_4_spell_2: get_team_player(team_1, 3).spell_1,
      team_1_player_5_champion_id: get_team_player(team_1, 4).champion_id,
      team_1_player_5_spell_1: get_team_player(team_1, 4).spell_1,
      team_1_player_5_spell_2: get_team_player(team_1, 4).spell_1,
      team_2_name: team_2.name,
      team_2_win: team_2.win,
      team_2_player_1_champion_id: get_team_player(team_2, 0).champion_id,
      team_2_player_1_spell_1: get_team_player(team_2, 0).spell_1,
      team_2_player_1_spell_2: get_team_player(team_2, 0).spell_1,
      team_2_player_2_champion_id: get_team_player(team_2, 1).champion_id,
      team_2_player_2_spell_1: get_team_player(team_2, 1).spell_1,
      team_2_player_2_spell_2: get_team_player(team_2, 1).spell_1,
      team_2_player_3_champion_id: get_team_player(team_2, 2).champion_id,
      team_2_player_3_spell_1: get_team_player(team_2, 2).spell_1,
      team_2_player_3_spell_2: get_team_player(team_2, 2).spell_1,
      team_2_player_4_champion_id: get_team_player(team_2, 3).champion_id,
      team_2_player_4_spell_1: get_team_player(team_2, 3).spell_1,
      team_2_player_4_spell_2: get_team_player(team_2, 3).spell_1,
      team_2_player_5_champion_id: get_team_player(team_2, 4).champion_id,
      team_2_player_5_spell_1: get_team_player(team_2, 4).spell_1,
      team_2_player_5_spell_2: get_team_player(team_2, 4).spell_1
    }

    # order our data to match our column order
    Enum.map(@columns, &Map.get(map, &1))
  end
end
