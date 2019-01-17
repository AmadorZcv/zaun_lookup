defmodule ZaunLookup.Zaun.Summoner do
  use Ecto.Schema
  import Ecto.Changeset
  alias ZaunLookup.Zaun.Match

  schema "summoners" do
    field :accountId, :string
    field :name, :string
    field :profileIconId, :integer
    field :puuid, :string
    many_to_many :matches, Match, join_through: "summoners_matches"
    timestamps()
  end

  @doc false
  def changeset(summoner, attrs) do
    summoner
    |> cast(attrs, [:puuid, :profileIconId, :name, :accountId])
    |> validate_required([:puuid, :profileIconId, :name, :accountId])
    |> unique_constraint(:puuid)
  end
end
