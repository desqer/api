defmodule Desqer.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :phone, :string, null: false
      add :password_hash, :string
      add :name, :string
      add :email, :string
      add :bio, :text
      add :professional, :boolean, default: false
      add :token, :string
      add :token_sent_at, :utc_datetime
      add :confirmed, :boolean, default: false
      add :deleted, :boolean, default: false

      timestamps()
    end

    create unique_index(:users, [:phone])
  end
end
