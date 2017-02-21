defmodule Desqer.Repo.Migrations.CreateAssignment do
  use Ecto.Migration

  def change do
    create table(:assignments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :sunday, {:array, :string}
      add :monday, {:array, :string}
      add :tuesday, {:array, :string}
      add :wednesday, {:array, :string}
      add :thursday, {:array, :string}
      add :friday, {:array, :string}
      add :saturday, {:array, :string}
      add :deleted, :boolean, default: false

      add :role_id, references(:roles, on_delete: :delete_all, type: :binary_id)
      add :service_id, references(:services, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:assignments, [:role_id])
    create index(:assignments, [:service_id])
  end
end
