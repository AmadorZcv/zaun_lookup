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

  def teams_from_api(_participants, _identities, _teams) do
    %TeamFromDetail{}
    |> Map.from_struct()
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
      team_players: team_players
    }
  end

  def winning_team(teams) do
    if teams[0]["win"] == "Win" do
      "blue"
    else
      "red"
    end
  end

  def team_name(team) do
    if team["teamId"] == 100 do
      "blue"
    else
      "red"
    end
  end
end
