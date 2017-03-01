defmodule Desqer.Repo.Migrations.CreateAppointment do
  use Ecto.Migration

  def change do
    create table(:appointments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :price, :integer
      add :starts_at, :naive_datetime
      add :ends_at, :naive_datetime
      add :notes, :text
      add :status, :string

      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :service_id, references(:services, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:appointments, [:user_id])
    create index(:appointments, [:service_id])
    create index(:appointments, [:status])
  end
end
