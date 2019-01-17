defmodule ZaunLookup.Zaun.Match do
  use Ecto.Schema
  import Ecto.Changeset
  alias ZaunLookup.Zaun.Summoner

  schema "matches" do
    field :gameVersion, :string
    field :regionGameId, :string
    many_to_many :summoners, Summoner, join_through: "summoners_matches"
    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:regionGameId, :gameVersion])
    |> validate_required([:regionGameId, :gameVersion])
    |> unique_constraint(:regionGameId)
  end
end
