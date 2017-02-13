defmodule Desqer.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_agent, :string
      add :remote_ip, :string
      add :revoked, :boolean

      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:sessions, [:user_id])
  end
end
