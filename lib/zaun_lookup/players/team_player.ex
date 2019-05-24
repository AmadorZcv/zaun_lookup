defmodule ZaunLookup.Players.TeamPlayer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams_players" do
    field :player_id, :id
    field :team_id, :id
    field :current_tier, :string
    field :current_points, :integer
    timestamps()
  end

  @doc false
  def changeset(team_player, attrs) do
    team_player
    |> cast(attrs, [:current_tier,:current_points])
    |> validate_required([])
  end
end
