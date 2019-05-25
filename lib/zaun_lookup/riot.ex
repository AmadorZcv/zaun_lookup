defmodule ZaunLookup.Riot do
  alias ZaunLookup.Riot.{Api, Endpoints}
  alias ZaunLookup.Players
  @regions Endpoints.regions()
  @queue "RANKED_SOLO_5x5"

  def update_from_league_into_user(user_api, user, region, tier) when user_api != nil do
    Players.update_user_from_league(
      Map.update!(user_api, "tier", &"#{tier} #{&1})}"),
      region,
      user
    )
  end

  def insert_from_league_into_user(user, region, tier) when user != nil do
    Players.create_user_from_league(Map.update!(user, "tier", &"#{tier} #{&1})}"), region)
  end

  def set_user(region, user) do
    Api.get_summoner_by_id(region, user.riot_id)
    |> Players.update_user_from_summoner(region, user)
  end

  def update_player(region, user) do
    user_api =
      Api.get_league_by_summoner_id(region, user.riot_id)
      |> Enum.find(fn p -> p["queueType"] == @queue end)

    update_from_league_into_user(user_api, user, region, user_api["tier"])
  end

  def set_tops_of_regions() do
    # Enum.each(@regions, &set_top_of_region(&1))
    Task.async_stream(@regions, &set_top_of_region(&1), timeout: 600_000, max_concurrency: 12)
    |> Enum.to_list()
  end

  def set_top_of_region(region) do
    IO.puts("Region é #{region}")
    challengers = Api.get_challenger_by_queue(region, @queue)["entries"]
    Enum.each(challengers, &insert_from_league_into_user(&1, region, "Challenger"))
    grandmasters = Api.get_grandmaster_by_queue(region, @queue)["entries"]
    Enum.each(grandmasters, &insert_from_league_into_user(&1, region, "Grandmaster"))
    masters = Api.get_master_by_queue(region, @queue)["entries"]
    Enum.each(masters, &insert_from_league_into_user(&1, region, "Master"))
  end
end
