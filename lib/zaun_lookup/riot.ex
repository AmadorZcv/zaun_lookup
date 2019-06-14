defmodule ZaunLookup.Riot do
  alias ZaunLookup.Riot.Api
  alias ZaunLookup.Players

  @queue "RANKED_SOLO_5x5"

  def update_players(region) do
    Players.list_users_to_update(region)
    |> Enum.map(&set_user(region.region, &1))
  end

  def update_from_league_into_user(user_api, user, region, tier) when user_api != nil do
    Players.update_user_from_league(
      Map.update!(user_api, "rank", &"#{tier} #{&1})}"),
      region,
      user
    )
  end

  def insert_from_league_into_user(user, region, tier) when user != nil do
    Players.create_user_from_league(Map.update!(user, "rank", &"#{tier} #{&1})}"), region)
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

  def set_top_of_region(region) do
    # IO.inspect("Region é #{region.region}")
    challengers = Api.get_challenger_by_queue(region.region, @queue)["entries"]
    Enum.each(challengers, &insert_from_league_into_user(&1, region.region, "Challenger"))
    grandmasters = Api.get_grandmaster_by_queue(region.region, @queue)["entries"]
    Enum.each(grandmasters, &insert_from_league_into_user(&1, region.region, "Grandmaster"))
    masters = Api.get_master_by_queue(region.region, @queue)["entries"]
    Enum.each(masters, &insert_from_league_into_user(&1, region.region, "Master"))
    3
  end

  def set_match_from_detail(region, match) do
    match_api = Api.get_match_by_id(region, match.game_id)
    Players.update_match_from_match_detail(match_api)
  end
end
