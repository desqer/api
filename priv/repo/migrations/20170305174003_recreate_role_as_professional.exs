defmodule Desqer.Repo.Migrations.RecreateRoleAsProfessional do
  use Ecto.Migration

  def up do
    alter table(:services) do
      remove :role_id
    end

    drop table(:roles)

    create table(:professionals, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :owner, :boolean, default: false
      add :deleted, :boolean, default: false

      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false
      add :venue_id, references(:venues, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:professionals, [:user_id])
    create index(:professionals, [:venue_id])

    alter table(:services) do
      add :professional_id, references(:professionals, on_delete: :delete_all, type: :binary_id), null: false
    end

    create index(:services, [:professional_id])
  end

  def down do
    alter table(:services) do
      remove :professional_id
    end

    drop table(:professionals)

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

    alter table(:services) do
      add :role_id, references(:roles, on_delete: :delete_all, type: :binary_id), null: false
    end

    create index(:services, [:role_id])
  end
end
