defmodule ZaunLookup.Riot.Structs.TeamFromDetail do
  alias ZaunLookup.Riot.Structs.{TeamFromDetail, TeamPlayerFromDetail}

  defstruct([
    :players,
    :name,
    :win,
    :first_dragon,
    :first_inhibitor,
    :first_baron,
    :first_blood,
    :first_tower,
    :first_rift_herald,
    :baron_kills,
    :tower_kills,
    :inhibitor_kills,
    :rift_herald_kills,
    :dragon_kills,
    :team_players
  ])

  def join_participants_and_identities(participants, identities) do
    Enum.map(participants, fn participant ->
      player_id = Enum.find(identities, &(participant["participantId"] == &1["participantId"]))
      Map.put_new(participant, "player_id", player_id)
    end)
  end

  def teams_from_api(participants, identities, teams) do
    joined_participants = join_participants_and_identities(participants, identities)
    blue_participants = Enum.filter(joined_participants, &(&1["teamId"] == 100))
    red_participants = Enum.filter(joined_participants, &(&1["teamId"] == 200))

    blue_team =
      Enum.at(teams, 0)
      |> team_from_api(blue_participants)

    red_team =
      Enum.at(teams, 1)
      |> team_from_api(red_participants)

    [blue_team, red_team]
  end

  def team_from_api(
        %{
          "teamId" => team_id,
          "win" => win_string,
          "firstDragon" => first_dragon,
          "firstBaron" => first_baron,
          "firstInhibitor" => first_inhibitor,
          "firstRiftHerald" => first_rift_herald,
          "firstBlood" => first_blood,
          "firstTower" => first_tower,
          "baronKills" => baron_kills,
          "riftHeraldKills" => rift_herald_kills,
          "inhibitorKills" => inhibitor_kills,
          "towerKills" => tower_kills,
          "dragonKills" => dragon_kills
        },
        participants
      ) do
    team_players = Enum.map(participants, &TeamPlayerFromDetail.from_api(&1))

    %TeamFromDetail{
      name: team_name(team_id),
      first_dragon: first_dragon,
      first_baron: first_baron,
      first_blood: first_blood,
      first_tower: first_tower,
      first_inhibitor: first_inhibitor,
      first_rift_herald: first_rift_herald,
      baron_kills: baron_kills,
      tower_kills: tower_kills,
      inhibitor_kills: inhibitor_kills,
      rift_herald_kills: rift_herald_kills,
      dragon_kills: dragon_kills,
      team_players: team_players,
      win: win(win_string)
    }
    |> Map.from_struct()
  end

  def win(string) do
    if string == "Win" do
      true
    else
      false
    end
  end

  def winning_team(teams) do
    if Enum.at(teams, 0)["win"] == "Win" do
      "blue"
    else
      "red"
    end
  end

  def team_name(team_id) do
    if team_id == 100 do
      "blue"
    else
      "red"
    end
  end
end
