defmodule Desqer.Repo.Migrations.RenameNameToRoleOnProfessional do
  use Ecto.Migration

  def change do
    rename table(:professionals), :name, to: :role
  end
end
