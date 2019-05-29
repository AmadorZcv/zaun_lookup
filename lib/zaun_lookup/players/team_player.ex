defmodule ZaunLookup.Players.TeamPlayer do
  use Ecto.Schema
  import Ecto.Changeset
  alias ZaunLookup.Players.{Team, User}

  schema "teams_players" do
    field :current_tier, :string
    field :current_points, :integer
    belongs_to :player, User
    belongs_to :team, Team
    timestamps()
  end

  @doc false
  def changeset(team_player, attrs) do
    team_player
    |> cast(attrs, [:current_tier, :current_points, :player_id, :team_id])
    |> validate_required([:player_id, :team_id])
  end
end
