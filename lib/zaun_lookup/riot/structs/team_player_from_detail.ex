defmodule ZaunLookup.Riot.Structs.TeamPlayerFromDetail do
  alias ZaunLookup.Riot.Structs.TeamPlayerFromDetail

  defstruct [
    :current_tier,
    :current_points,
    :champion_id,
    :spell_1,
    :spell_2,
    :lane,
    :role,
    :player_id,
    :team_id
  ]

  def from_api(%{}) do
    %TeamPlayerFromDetail{}
    |> Map.from_struct()
  end
end
