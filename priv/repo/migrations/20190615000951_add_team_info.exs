defmodule ZaunLookup.Repo.Migrations.AddTeamInfo do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :first_dragon, :boolean
      add :first_inhibitor, :boolean
      add :first_baron, :boolean
      add :first_blood, :boolean
      add :first_tower, :boolean
      add :first_rift_herald, :boolean
      add :baron_kills, :integer
      add :tower_kills, :integer
      add :inhibitor_kills, :integer
      add :rift_herald_kills, :integer
      add :dragon_kills, :integer
    end
  end
end
