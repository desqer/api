defmodule Desqer.Repo.Migrations.DropAssignment do
  use Ecto.Migration

  def change do
    drop table(:assignments)
  end
end
