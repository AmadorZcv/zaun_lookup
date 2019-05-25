defmodule ZaunLookup.Repo.Migrations.AddFetchedMatch do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :fetched, :boolean
    end
  end
end
