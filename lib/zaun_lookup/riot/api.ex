defmodule ZaunLookup.Riot.Api do
  alias ZaunLookup.Riot.Routes

  def request(url, headers \\ %{}) do
    headers =
      %{"X-Riot-Token": "RGAPI-736a7234-4b13-4e4a-ba70-c3c38d8b1e09"}
      |> Map.merge(headers)

    case HTTPoison.get(url, headers) do
      {:ok, response} ->
        {:ok, Jason.decode!(response.body)}

      {:error, reason} ->
        IO.puts("Reason é ")
        IO.inspect(reason)
        {:error, reason}
    end
  end

  def handle_queue(url) do
    case request(url) do
      {:ok, response} ->
        response

      {:error, _} ->
        %{"entries" => []}
    end
  end

  def handle_summoner(url) do
    case request(url) do
      {:ok, response} ->
        response

      {:error, _} ->
        %{}
    end
  end

  def handle_match_list(url) do
    case request(url) do
      {:ok, response} ->
        response

      {:error, _} ->
        %{"matches" => []}
    end
  end

  def handle_match(url) do
    case request(url) do
      {:ok, %{"message" => _message, "status_code" => status}} ->
        %{"status_code" => status}

      {:ok, response} ->
        response

      {:error, _} ->
        %{"status" => "asd"}
    end
  end

  def get_summoner_by_id(region, id) do
    url = Routes.summoner_by_summoner_id(region, id)
    handle_summoner(url)
  end

  def get_summoner_by_name(region, name) do
    url = Routes.summoner_by_summoner_name(region, name)
    handle_summoner(url)
  end

  def get_summoner_by_puuid(region, puuid) do
    url = Routes.summoner_by_puuid(region, puuid)
    request(url)
  end

  def get_match_by_id(region, match_id) do
    url = Routes.match_by_match_id(region, match_id)
    handle_match(url)
  end

  def get_matches_by_account_id(region, account_id, begin_index \\ 0, queue \\ 420) do
    url = Routes.matches_by_account_id(region, account_id, begin_index, queue)
    handle_match_list(url)
  end

  def get_challenger_by_queue(region, queue) do
    url = Routes.challenger_by_queue(region, queue)
    handle_queue(url)
  end

  def get_grandmaster_by_queue(region, queue) do
    url = Routes.grandmaster_by_queue(region, queue)
    handle_queue(url)
  end

  def get_master_by_queue(region, queue) do
    url = Routes.master_by_queue(region, queue)
    handle_queue(url)
  end

  def get_league_by_summoner_id(region, summoner_id) do
    url = Routes.entries_by_summoner_id(region, summoner_id)
    request(url)
  end
end
