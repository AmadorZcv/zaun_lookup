defmodule ZaunLookup.Repo.Migrations.SetBigInt do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      modify :game_id, :bigint
    end
  end
end
