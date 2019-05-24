defmodule ZaunLookup.Players.TeamPlayer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams_players" do
    field :player_id, :id
    field :team_id, :id

    timestamps()
  end

  @doc false
  def changeset(team_player, attrs) do
    team_player
    |> cast(attrs, [])
    |> validate_required([])
  end
end
