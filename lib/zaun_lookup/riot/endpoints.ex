defmodule ZaunLookup.Riot.Endpoints do
  @https "https://"
  @br "#{@https}br1.api.riotgames.com/"
  @eune "#{@https}eun1.api.riotgames.com/"
  @euw "#{@https}euw1.api.riotgames.com/"
  @jp "#{@https}jp1.api.riotgames.com/"
  @kr "#{@https}kr.api.riotgames.com/"
  @lan "#{@https}la1.api.riotgames.com/"
  @las "#{@https}la2.api.riotgames.com/"
  @na "#{@https}na1.api.riotgames.com/"
  @oce "#{@https}oc1.api.riotgames.com/"
  @tr "#{@https}tr1.api.riotgames.com/"
  @ru "#{@https}ru.api.riotgames.com/"
  # @pbe "#{@https}pbe1.api.riotgames.com/"

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

        # "PBE" ->
        # @pbe
    end
  end

  @regions ["BR", "EUNE", "JP", "KR", "LAN", "LAS", "NA", "OCE", "TR", "RU"]
  def regions, do: @regions
end
