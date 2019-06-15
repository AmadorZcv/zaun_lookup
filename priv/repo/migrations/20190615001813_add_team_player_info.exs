defmodule ZaunLookup.Repo.Migrations.AddTeamPlayerInfo do
  use Ecto.Migration

  def change do
    alter table(:teams_players) do
      add :champion_id, :integer
      add :spell_1, :integer
      add :spell_2, :integer
      add :lane, :string
      add :role, :string
    end
  end
end
