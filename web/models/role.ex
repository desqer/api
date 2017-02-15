defmodule Desqer.Role do
  use Desqer.Web, :model

  schema "roles" do
    belongs_to :user, Desqer.User
    belongs_to :venue, Desqer.Venue

    field :name, :string
    field :owner, :boolean, default: false
    field :deleted, :boolean, default: false

    timestamps()
  end
end
