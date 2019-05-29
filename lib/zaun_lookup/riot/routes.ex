defmodule ZaunLookup.Riot.Routes do
  alias ZaunLookup.Riot.Endpoints

  @summoners "lol/summoner/v4/summoners/"
  @summoner_by_puuid "#{@summoners}by-puuid/"
  @summoner_by_summoner_name "#{@summoners}by-name/"

  def summoner_by_summoner_id(region, summoner_id) do
    endpoint = Endpoints.get_endpoint(region)
    "#{endpoint}#{@summoners}#{summoner_id}"
  end

  def summoner_by_summoner_name(region, name) do
    endpoint = Endpoints.get_endpoint(region)
    "#{endpoint}#{@summoner_by_summoner_name}#{name}"
  end

  def summoner_by_puuid(region, puuid) do
    endpoint = Endpoints.get_endpoint(region)
    "#{endpoint}#{@summoner_by_puuid}#{puuid}"
  end

  @match "lol/match/v4/"
  @matches_by_account_id "#{@match}matchlists/by-account/"
  @match_by_match_id "#{@match}matches/"

  def matches_by_account_id(region, account_id) do
    endpoint = Endpoints.get_endpoint(region)
    "#{endpoint}#{@matches_by_account_id}#{account_id}"
  end

  def match_by_match_id(region, match_id) do
    endpoint = Endpoints.get_endpoint(region)
    "#{endpoint}#{@match_by_match_id}#{match_id}"
  end

  @league "lol/league/v4/"
  @entries_by_summoner_id "#{@league}entries/by-summoner/"
  @challenger_leagues_by_queue "#{@league}challengerleagues/by-queue/"
  @grandmaster_leagues_by_queue "#{@league}grandmasterleagues/by-queue/"
  @master_leagues_by_queue "#{@league}grandmasterleagues/by-queue/"
  def entries_by_summoner_id(region, summoner_id) do
    endpoint = Endpoints.get_endpoint(region)
    "#{endpoint}#{@entries_by_summoner_id}#{summoner_id}"
  end

  def challenger_by_queue(region, queue) do
    endpoint = Endpoints.get_endpoint(region)
    "#{endpoint}#{@challenger_leagues_by_queue}#{queue}"
  end

  def grandmaster_by_queue(region, queue) do
    endpoint = Endpoints.get_endpoint(region)
    "#{endpoint}#{@grandmaster_leagues_by_queue}#{queue}"
  end

  def master_by_queue(region, queue) do
    endpoint = Endpoints.get_endpoint(region)
    "#{endpoint}#{@master_leagues_by_queue}#{queue}"
  end
end
