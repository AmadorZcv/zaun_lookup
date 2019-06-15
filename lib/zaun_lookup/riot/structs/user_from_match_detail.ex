defmodule ZaunLookup.Riot.Structs.UserFromMatchDetail do
  alias ZaunLookup.Riot.Structs.UserFromMatchDetail
  @enforce_keys [:name, :riot_id, :last_updated, :region, :account_id]
  defstruct([:name, :riot_id, :last_updated, :region, :account_id])

  def from_api(
        %{
          "summonerName" => name,
          "summonerId" => riot_id,
          "accountId" => account_id
        },
        region
      ) do
    %UserFromMatchDetail{
      name: name,
      account_id: account_id,
      riot_id: riot_id,
      region: region,
      last_updated: Time.utc_now() |> Time.truncate(:second)
    }
    |> Map.from_struct()
  end
end
