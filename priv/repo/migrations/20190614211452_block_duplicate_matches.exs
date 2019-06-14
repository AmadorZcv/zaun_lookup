defmodule ZaunLookup.Repo.Migrations.BlockDuplicateMatches do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :region, :string
    end

    create unique_index(:matches, [:region, :game_id], name: :unique_match_on_region)
  end
end
