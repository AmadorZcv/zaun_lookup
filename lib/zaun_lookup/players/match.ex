defmodule ZaunLookup.Players.Match do
  use Ecto.Schema
  import Ecto.Changeset

  schema "matches" do
    field :game_creation, :integer
    field :game_duration, :integer
    field :game_id, :integer
    field :game_mode, :string
    field :game_type, :string
    field :game_version, :string
    field :map_id, :integer
    field :platform_id, :string
    field :queue_id, :integer
    field :season_id, :integer
    field :winning_team, :string
    field :fetched, :boolean
    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [
      :season_id,
      :queue_id,
      :game_id,
      :game_version,
      :platform_id,
      :game_mode,
      :map_id,
      :game_type,
      :game_duration,
      :game_creation,
      :winning_team,
      :fetched
    ])
    |> validate_required([
      :game_id
    ])
  end
end
