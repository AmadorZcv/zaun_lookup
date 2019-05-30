defmodule ZaunLookup.Repo.Migrations.AddBeginTotalGames do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :begin_index, :integer
      add :total_games, :integer
    end
  end
end
