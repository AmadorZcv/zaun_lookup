defmodule ZaunLookup.Riot.Api do
  alias ZaunLookup.Riot.Routes

  def request(url) do
    headers = ["X-Riot-Token": "RGAPI-4da6aa59-c677-493f-ab26-5ebecfdd3241"]
    HTTPoison.get!(url, headers).body |> Jason.decode!()
  end

  def get_summoner_by_name(region, name) do
    url = Routes.summoner_by_summoner_name(region, name)
    request(url)
  end

  def get_summoner_by_puuid(region, puuid) do
    url = Routes.summoner_by_puuid(region, puuid)
    request(url)
  end
  def get_match_by_id(region, match_id) do
    url = Routes.match_by_match_id(region, match_id)
    request(url)
  end

  def get_matches_by_account_id(region, account_id) do
    url = Routes.matches_by_account_id(region, account_id)
    request(url)
  end

  def get_challenger_by_queue(region,queue) do
    url = Routes.challenger_by_queue(region, queue)
    request(url)
  end

  def get_grandmaster_by_queue(region,queue) do
    url = Routes.grandmaster_by_queue(region, queue)
    request(url)
  end
  def get_master_by_queue(region,queue) do
    url = Routes.master_by_queue(region, queue)
    request(url)
  end

end
