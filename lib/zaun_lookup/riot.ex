defmodule ZaunLookup.Riot do
  alias ZaunLookup.Riot.{Api, Endpoints}
  alias ZaunLookup.Repo

  alias ZaunLookup.Players.{User, Match}
  @regions Endpoints.regions()
  @queue "RANKED_SOLO_5x5"

  def player_struct_from_league(player, region) do
    %{
      name: player["summonerName"],
      tier: player["rank"],
      points: player["leaguePoints"],
      riot_id: player["summonerId"],
      last_updated: Time.utc_now() |> Time.truncate(:second),
      region: region
    }
  end

  def player_struct_from_summoner(player, region) do
    IO.inspect(player)
    %{
      name: player["name"],
      riot_id: player["id"],
      last_updated: Time.utc_now() |> Time.truncate(:second),
      region: region,
      account_id: player["accountId"],
      puuid: player["puuid"]
    }
  end

  def set_player(region, player) do
    playerNew = Api.get_summoner_by_id(region, player.riot_id)
    update_from_summoner_into_user(player, region, playerNew)
  end

  def update_player(region, player) do
    matches = Api.get_matches_by_account_id(region, player.account_id)

    playerApi =
      Api.get_league_by_summoner_id(region, player.riot_id)
      |> Enum.find(fn p -> p["queueType"] == @queue end)

    update_from_league_into_user(player, region, playerApi)
    Enum.each(matches, &insert_from_matches_into_matches(&1))
  end

  def insert_from_matches_into_matches(match) do
    Repo.insert!(%Match{
      game_id: match["gameId"],
      fetched: false
    })
  end

  def update_from_league_into_user(user, region, userApi) when userApi != nil do
    new_user = player_struct_from_league(userApi, region)
    ZaunLookup.Players.update_user(user, new_user)
  end

  def update_from_summoner_into_user(user, region, userApi) do
    new_user = player_struct_from_summoner(userApi, region)
    ZaunLookup.Players.update_user(user, new_user)
  end

  def insert_from_league_into_user(user, region) when user != nil do
    user
    |> player_struct_from_league(region)
    |> ZaunLookup.Players.create_user()
  end

  def set_tops_of_regions() do
    # Enum.each(@regions, &set_top_of_region(&1))
    Task.async_stream(@regions, &set_top_of_region(&1), timeout: 600_000, max_concurrency: 12)
    |> Enum.to_list()
  end

  def set_top_of_region(region) do
    IO.puts("Region é #{region}")
    challengers = Api.get_challenger_by_queue(region, @queue)["entries"]
    Enum.each(challengers, &insert_from_league_into_user(&1, region))
    grandmasters = Api.get_grandmaster_by_queue(region, @queue)["entries"]
    Enum.each(grandmasters, &insert_from_league_into_user(&1, region))
    masters = Api.get_master_by_queue(region, @queue)["entries"]
    Enum.each(masters, &insert_from_league_into_user(&1, region))
  end
end
