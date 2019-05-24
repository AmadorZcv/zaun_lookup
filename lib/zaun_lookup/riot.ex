defmodule ZaunLookup.Riot do
  alias ZaunLookup.Riot.{Api, Endpoints}
  alias ZaunLookup.Repo

  alias ZaunLookup.Players.User
  @regions Endpoints.regions()
  @queue "RANKED_SOLO_5x5"
  def insert_from_league_into_user(user) do
    Repo.insert!(%User{
      name: user["summonerName"],
      tier: user["rank"],
      points: user["leaguePoints"],
      riot_id: user["summonerId"],
      last_updated: Time.utc_now() |> Time.truncate(:second)
    })
  end

  def set_tops_of_regions() do
    #Enum.each(@regions, &set_top_of_region(&1))
    Task.async_stream(@regions, & set_top_of_region(&1), [timeout: 60000, max_concurrency: 12])
    |> Enum.to_list()
  end

  def set_top_of_region(region) do
    IO.puts("Region é #{region}")
    challengers = Api.get_challenger_by_queue(region, @queue)["entries"]
    Enum.each(challengers, &insert_from_league_into_user(&1))
    grandmasters = Api.get_grandmaster_by_queue(region, @queue)["entries"]
    Enum.each(grandmasters, &insert_from_league_into_user(&1))
    masters = Api.get_master_by_queue(region, @queue)["entries"]
    Enum.each(masters, &insert_from_league_into_user(&1))
  end
end
