defmodule ZaunLookup.Riot.Structs.UserFromMatch do
  alias ZaunLookup.Riot.Structs.UserFromMatch
  @enforce_keys [:name, :tier, :riot_id, :last_updated, :region, :account_id]
  defstruct([:name, :tier, :riot_id, :last_updated, :region, :account_id])

  def from_api(%{
        "summonerName" => name,
        "rank" => tier,
        "summonerId" => riot_id,
        "accountId" => account_id,
        "platformId" => region
      }) do
    %UserFromMatch{
      name: name,
      tier: tier,
      account_id: account_id,
      riot_id: riot_id,
      region: region,
      last_updated: Time.utc_now() |> Time.truncate(:second)
    }
    |> Map.from_struct()
  end
end
