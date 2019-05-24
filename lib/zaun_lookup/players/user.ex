defmodule ZaunLookup.Players.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :account_id, :string
    field :name, :string
    field :puuid, :string
    field :revision_date, :integer
    field :riot_id, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :puuid, :account_id, :riot_id, :revision_date])
    |> validate_required([:name, :puuid, :account_id, :riot_id, :revision_date])
    |> unique_constraint(:puuid)
  end
end
