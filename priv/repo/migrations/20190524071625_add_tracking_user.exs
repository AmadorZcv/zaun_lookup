defmodule ZaunLookup.Repo.Migrations.AddTrackingUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :last_updated, :time
    end
  end
end
