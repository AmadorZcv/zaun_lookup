defmodule ZaunLookup.Repo.Migrations.ChangeToBigint do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      modify :game_creation, :bigint
      modify :game_duration, :bigint
    end
  end
end
