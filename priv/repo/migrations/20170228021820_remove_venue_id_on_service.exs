defmodule Desqer.Repo.Migrations.RemoveVenueIdOnService do
  use Ecto.Migration

  def change do
    alter table(:services) do
      remove :venue_id
    end
  end
end
