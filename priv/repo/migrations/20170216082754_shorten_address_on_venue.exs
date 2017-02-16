defmodule Desqer.Repo.Migrations.ShortenAddressOnVenue do
  use Ecto.Migration

  def change do
    alter table(:venues) do
      remove :street
      remove :number
      remove :complement
      remove :neighborhood
      remove :city
      remove :state
      remove :country
      remove :zip_code

      add :address, :string
    end
  end
end
