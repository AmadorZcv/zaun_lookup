defmodule ZaunLookup.Repo.Migrations.CreateTeamsPlayers do
  use Ecto.Migration

  def change do
    create table(:teams_players) do
      add :player_id, references(:users, on_delete: :delete_all)
      add :team_id, references(:teams, on_delete: :nothing)

      timestamps()
    end

    create index(:teams_players, [:player_id])
    create index(:teams_players, [:team_id])
  end
end
