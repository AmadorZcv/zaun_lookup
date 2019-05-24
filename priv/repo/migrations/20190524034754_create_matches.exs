defmodule ZaunLookup.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :season_id, :integer
      add :queue_id, :integer
      add :game_id, :integer
      add :game_version, :string
      add :platform_id, :string
      add :game_mode, :string
      add :map_id, :integer
      add :game_type, :string
      add :game_duration, :integer
      add :game_creation, :integer
      add :winning_team, :string

      timestamps()
    end

  end
end
