defmodule Desqer.Repo.Migrations.CreateRole do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :owner, :boolean, default: false
      add :deleted, :boolean, default: false

      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false
      add :venue_id, references(:venues, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:roles, [:user_id])
    create index(:roles, [:venue_id])
  end
end
