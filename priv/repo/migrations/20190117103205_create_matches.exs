defmodule ZaunLookup.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :regionGameId, :string
      add :gameVersion, :string

      timestamps()
    end

    create unique_index(:matches, [:regionGameId])
  end
end
