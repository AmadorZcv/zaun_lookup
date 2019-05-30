defmodule ZaunLookup.Players.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :account_id, :string
    field :name, :string
    field :puuid, :string
    field :revision_date, :integer
    field :riot_id, :string
    field :last_updated, :time
    field :region, :string
    field :tier, :string
    field :points, :integer
    field :total_games, :integer
    field :begin_index, :integer
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :puuid,
      :account_id,
      :riot_id,
      :revision_date,
      :last_updated,
      :region,
      :points,
      :total_games,
      :begin_index
    ])
    |> unique_constraint(:puuid)
    |> unique_constraint(:unique_on_region, name: :unique_on_region)
  end
end
