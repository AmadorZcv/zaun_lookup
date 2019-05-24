defmodule ZaunLookup.Riot.Endpoints do
  @br "br1.api.riotgames.com/"
  @eune "eun1.api.riotgames.com/"
  @euw "euw1.api.riotgames.com/"
  @jp "jp1.api.riotgames.com/"
  @kr "kr.api.riotgames.com/"
  @lan "la1.api.riotgames.com/"
  @las "la2.api.riotgames.com/"
  @na "na1.api.riotgames.com/"
  @oce "oc1.api.riotgames.com/"
  @tr "tr1.api.riotgames.com/"
  @ru "ru.api.riotgames.com/"
  @pbe "pbe1.api.riotgames.com/"

  def get_endpoint(region) do
    case region do
      "BR" ->
        @br

      "EUNE" ->
        @eune

      "EUW" ->
        @euw

      "JP" ->
        @jp

      "KR" ->
        @kr

      "LAN" ->
        @lan

      "LAS" ->
        @las

      "NA" ->
        @na

      "OCE" ->
        @oce

      "TR" ->
        @tr

      "RU" ->
        @ru

      "PBE" ->
        @pbe
    end
  end
  @regions ["BR","EUNE","JP","KR","LAN","LAS","NA","OCE","TR","RU","PBE"]
  def regions, do: @regions
end
