defmodule ZaunLookup.Riot.Structs.MatchFromDetail do
  alias ZaunLookup.Riot.Structs.{MatchFromDetail, TeamFromDetail}

  defstruct([
    :game_id,
    :platform_id,
    :queue_id,
    :season_id,
    :game_creation,
    :game_duration,
    :game_mode,
    :game_type,
    :game_version,
    :map_id,
    :fetched,
    :teams,
    :winning_team
  ])

  def from_api(%{
        "gameId" => game_id,
        "platformId" => platform_id,
        "queue" => queue_id,
        "season" => season_id,
        "gameCreation" => game_creation,
        "gameDuration" => game_duration,
        "gameMode" => game_mode,
        "gameType" => game_type,
        "gameVersion" => game_version,
        "mapId" => map_id,
        "participants" => participants,
        "participantIdentities" => identities,
        "teams" => teams_api
      }) do
    teams = TeamFromDetail.teams_from_api(participants, identities, teams_api)

    %MatchFromDetail{
      game_id: game_id,
      platform_id: platform_id,
      queue_id: queue_id,
      season_id: season_id,
      game_creation: game_creation,
      game_duration: game_duration,
      game_mode: game_mode,
      game_type: game_type,
      game_version: game_version,
      map_id: map_id,
      fetched: true,
      teams: teams,
      winning_team: TeamFromDetail.winning_team(teams_api)
    }
    |> Map.from_struct()
  end
end
