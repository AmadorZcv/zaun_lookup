defmodule ZaunLookup.Players.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :win, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :win])
    |> validate_required([:name, :win])
  end
end
