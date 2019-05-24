defmodule ZaunLookup.Repo.Migrations.AddTrackingMatch do
  use Ecto.Migration

  def change do
    alter table(:teams_players) do
      add :current_tier, :string
      add :current_points, :integer
    end
  end
end
