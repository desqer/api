defmodule Desqer.Repo.Migrations.CreatePhone do
  use Ecto.Migration

  def change do
    create table(:phones, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string
      add :value, :string, null: false
      add :deleted, :boolean, default: false

      add :venue_id, references(:venues, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:phones, [:venue_id])
  end
end
