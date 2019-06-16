defmodule ZaunLookup.Riot do
  alias ZaunLookup.Riot.Api
  alias ZaunLookup.{Players, Matches}

  @queue "RANKED_SOLO_5x5"

  def update_players(region) do
    Players.list_users_to_update(region)
    |> Enum.map(&set_user(region.region, &1))
  end

  def update_from_league_into_user(user_api, user, region, tier) do
    Players.update_user_from_league(
      Map.update!(user_api, "rank", &"#{tier} #{&1})}"),
      region,
      user
    )
  end

  def insert_from_league_into_user(user, region, tier) do
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

  def filter_match_list(match) do
    case match do
      %{"status" => _status_code} ->
        false

      %{"matches" => _} ->
        true
    end
  end

  def update_matches_list(region) do
    players_matches =
      Players.list_users_matches_to_update(region)
      |> Enum.map(fn player ->
        {player,
         Api.get_matches_by_account_id(
           region.region,
           player.account_id,
           player.begin_index
         )}
      end)

    count = Enum.count(players_matches)

    players_matches
    |> Enum.filter(fn {_, match} -> filter_match_list(match) end)
    |> Enum.map(fn {_, match} -> match["matches"] end)
    |> Enum.concat()
    |> Enum.map(fn match -> Map.put_new(match, "region", region.region) end)
    |> Matches.create_matches_from_match_list()

    players_matches
    |> Enum.filter(fn {_, match} -> filter_match_list(match) end)
    |> Enum.each(fn {player, match} ->
      Players.update_from_match_list(player, match)
    end)

    count
  end

  # Pega o id ou cria usuario e retorna o id
  def get_player_id(player_api, region) do
    case Players.get_user_from_match(player_api["summonerId"], region) do
      nil ->
        with({:ok, player} <- Players.insert_user_from_match(player_api, region)) do
          player.id
        end

      player ->
        case Players.update_user_from_match(player, player_api, region) do
          {:ok, updated_player} ->
            updated_player.id

          _ ->
            player.id
        end
    end
  end

  def set_match(match, region) do
    IO.puts("Set MAtch")
    IO.inspect(Map.keys(match))
    IO.inspect(match["status"])

    participantIdentities =
      Enum.map(match["participantIdentities"], fn participant ->
        Map.put_new(participant, "player_id", get_player_id(participant["player"], region.region))
      end)

    # Atualizar identities com o player_id
    Matches.update_match_from_match_detail(
      Map.put(match, "participantIdentities", participantIdentities),
      region
    )
  end

  def filter_matches(match) do
    case match do
      %{"status" => _status_code} ->
        false

      %{"participantIdentities" => _} ->
        true
    end
  end

  def update_matches(region) do
    IO.puts("Updating")

    matches =
      Matches.list_matches_to_update(region)
      |> Enum.map(fn match -> Api.get_match_by_id(region.region, match.game_id) end)

    count = Enum.count(matches)

    matches
    |> Enum.filter(&filter_matches(&1))
    |> Enum.map(&set_match(&1, region))

    count
  end
end
