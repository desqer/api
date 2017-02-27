defmodule Desqer.Repo.Migrations.AddAssignmentFieldsOnService do
  use Ecto.Migration

  def change do
    alter table(:services) do
      add :sunday, {:array, :string}
      add :monday, {:array, :string}
      add :tuesday, {:array, :string}
      add :wednesday, {:array, :string}
      add :thursday, {:array, :string}
      add :friday, {:array, :string}
      add :saturday, {:array, :string}

      add :role_id, references(:roles, on_delete: :delete_all, type: :binary_id)
    end

    create index(:services, [:role_id])
  end
end
