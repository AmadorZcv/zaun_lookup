defmodule ZaunLookup.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :win, :boolean, default: false, null: false
      add :match_id, references(:matches, on_delete: :delete_all)
      timestamps()
    end

    create index(:teams, [:match_id])
  end
end
