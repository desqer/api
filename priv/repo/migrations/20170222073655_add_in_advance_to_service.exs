defmodule Desqer.Repo.Migrations.AddInAdvanceToService do
  use Ecto.Migration

  def change do
    alter table(:services) do
      add :in_advance, :integer
    end
  end
end
