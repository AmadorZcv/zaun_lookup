defmodule ZaunLookup.Riot.Structs.TeamPlayerFromDetail do
  alias ZaunLookup.Riot.Structs.TeamPlayerFromDetail

  defstruct [
    :champion_id,
    :spell_1,
    :spell_2,
    :lane,
    :role,
    :player_id
  ]

  def from_api(%{
        "spell1Id" => spell_1,
        "spell2Id" => spell_2,
        "timeline" => timeline,
        "player_id" => player_id,
        "championId" => champion_id
      }) do
    lane = timeline["lane"]
    role = timeline["role"]

    %TeamPlayerFromDetail{
      spell_1: spell_1,
      spell_2: spell_2,
      lane: lane,
      role: role,
      player_id: player_id,
      champion_id: champion_id
    }
    |> Map.from_struct()
  end
end
