defmodule ZaunLookup.Riot.Structs.UserFromLeague do
  alias ZaunLookup.Riot.Structs.UserFromLeague
  @enforce_keys [:name, :tier, :points, :riot_id, :last_updated, :region]
  defstruct([:name, :tier, :points, :riot_id, :last_updated, :region])

  def from_api(
        %{
          "summonerName" => name,
          "rank" => tier,
          "leaguePoints" => points,
          "summonerId" => riot_id
        },
        region
      ) do
    %UserFromLeague{
      name: name,
      tier: tier,
      points: points,
      riot_id: riot_id,
      region: region,
      last_updated: Time.utc_now() |> Time.truncate(:second)
    }
    |> Map.from_struct()
  end
end
