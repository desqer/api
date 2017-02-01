defmodule Desqer.Repo.Migrations.EnableUuidExtension do
  use Ecto.Migration

  def up do
    execute ~s(CREATE EXTENSION IF NOT EXISTS "uuid-ossp")
  end

  def down do
    execute ~s(DROP EXTENSION IF EXISTS "uuid-ossp")
  end
end
