defmodule Desqer.User do
  use Desqer.Web, :model

  schema "users" do
    field :phone, :string
    field :password_hash, :string
    field :name, :string
    field :email, :string
    field :bio, :string
    field :professional, :boolean, default: false
    field :token, :string
    field :token_sent_at, Ecto.DateTime
    field :confirmed, :boolean, default: false
    field :deleted, :boolean, default: false

    field :password, :string, virtual: true
    field :current_password, :string, virtual: true

    timestamps()
  end
end
