defmodule ZaunLookup.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :puuid, :string
      add :account_id, :string
      add :riot_id, :string
      add :revision_date, :integer

      timestamps()
    end

    create unique_index(:users, [:puuid])
  end
end
