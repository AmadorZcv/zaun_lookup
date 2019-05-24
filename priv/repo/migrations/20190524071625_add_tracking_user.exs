defmodule ZaunLookup.Repo.Migrations.AddTrackingUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :last_updated, :time
      add :region, :string
      add :points, :integer
      add :tier, :string
    end
    create unique_index(:users, [:region, :riot_id],name: :unique_on_region)
  end
end
