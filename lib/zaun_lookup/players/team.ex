defmodule ZaunLookup.Players.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :win, :boolean, default: false
    field :first_dragon, :boolean
    field :first_inhibitor, :boolean
    field :first_baron, :boolean
    field :first_blood, :boolean
    field :first_tower, :boolean
    field :first_rift_herald, :boolean
    field :baron_kills, :integer
    field :tower_kills, :integer
    field :inhibitor_kills, :integer
    field :rift_herald_kills, :integer
    field :dragon_kills, :integer
    belongs_to :match, ZaunLookup.Players.Match
    has_many :team_players, ZaunLookup.Players.TeamPlayer
    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [
      :name,
      :win,
      :match_id,
      :first_dragon,
      :first_inhibitor,
      :first_baron,
      :first_blood,
      :first_tower,
      :first_rift_herald,
      :baron_kills,
      :tower_kills,
      :inhibitor_kills,
      :rift_herald_kills,
      :dragon_kills
    ])
    |> validate_required([:win, :match_id])
  end
end
