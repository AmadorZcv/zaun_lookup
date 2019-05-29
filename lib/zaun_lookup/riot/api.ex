defmodule ZaunLookup.Riot.Api do
  alias ZaunLookup.Riot.Routes

  def request(url) do
    headers = ["X-Riot-Token": "RGAPI-1642232d-53b1-42f1-b8b4-df6876794045"]
    HTTPoison.get!(url, headers).body |> Jason.decode!()
  end

  def get_summoner_by_id(region, id) do
    url = Routes.summoner_by_summoner_id(region, id)
    request(url)
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

  def get_challenger_by_queue(region, queue) do
    url = Routes.challenger_by_queue(region, queue)
    request(url)
  end

  def get_grandmaster_by_queue(region, queue) do
    url = Routes.grandmaster_by_queue(region, queue)
    request(url)
  end

  def get_master_by_queue(region, queue) do
    url = Routes.master_by_queue(region, queue)
    request(url)
  end

  def get_league_by_summoner_id(region, summoner_id) do
    url = Routes.entries_by_summoner_id(region, summoner_id)
    request(url)
  end
end
