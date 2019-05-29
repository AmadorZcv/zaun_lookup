defmodule ZaunLookup.Players.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :win, :boolean, default: false
    belongs_to :match, ZaunLookup.Players.Match
    has_many :team_players, ZaunLookup.Players.TeamPlayer
    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :win, :match_id])
    |> validate_required([:win, :match_id])
  end
end
