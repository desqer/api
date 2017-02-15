defmodule Desqer.Repo.Migrations.CreateLink do
  use Ecto.Migration

  def change do
    create table(:links, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string
      add :name, :string
      add :url, :string, null: false
      add :deleted, :boolean, default: false

      add :venue_id, references(:venues, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:links, [:venue_id])
  end
end
