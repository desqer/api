defmodule Desqer.Repo.Migrations.CreateVenue do
  use Ecto.Migration

  def change do
    create table(:venues, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :lat, :float
      add :lon, :float
      add :street, :string
      add :number, :string
      add :complement, :string
      add :neighborhood, :string
      add :city, :string
      add :state, :string
      add :country, :string
      add :zip_code, :string
      add :deleted, :boolean, default: false

      timestamps()
    end
  end
end
