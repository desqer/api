defmodule Desqer.Repo.Migrations.CreateService do
  use Ecto.Migration

  def change do
    create table(:services, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :price, :integer
      add :duration, :integer
      add :status, :string
      add :need_approval, :boolean, default: false
      add :online_scheduling, :boolean, default: false
      add :deleted, :boolean, default: false

      add :venue_id, references(:venues, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:services, [:venue_id])
    create index(:services, [:status])
  end
end
