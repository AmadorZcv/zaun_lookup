defmodule ZaunLookup.Riot.Routes do
  alias ZaunLookup.Riot.Endpoints
  @summoners "lol/summoner/v4/summoners/"
  @summoner_by_puuid "#{@summoners}by-puuid/"
  @summoner_by_summoner_name "#{@summoners}by-name/"

  def summoner_by_summoner_name(region,name) do
    endpoint = Endpoints.get_endpoint(region)
    "#{endpoint}#{@summoner_by_summoner_name}#{name}"
  end
  def summoner_by_puuid(region,puuid) do
    endpoint = Endpoints.get_endpoint(region)
    "#{endpoint}#{@summoner_by_puuid}#{puuid}"
  end

  @match "/lol/match/v4/"
  @match_by_account_id "#{@match}matchlists/by-account/"
  @matches_by_match_id "#{@match}matches/"

  def match_by_account_id(region,account_id) do
    endpoint = Endpoints.get_endpoint(region)
    "#{endpoint}#{@match_by_account_id}#{account_id}"
  end

  def matches_by_match_id(region,match_id) do
    endpoint = Endpoints.get_endpoint(region)
    "#{endpoint}#{@matches_by_match_id}#{match_id}"
  end

end
