defmodule Desqer.User do
  use Desqer.Web, :model

  schema "users" do
    has_many :sessions, Desqer.Session
    has_many :professionals, Desqer.Professional

    field :phone, Desqer.Type.Phone
    field :password_hash, Desqer.Type.String
    field :name, Desqer.Type.String
    field :email, Desqer.Type.String
    field :bio, Desqer.Type.String
    field :professional, :boolean, default: false
    field :token, Desqer.Type.String
    field :token_sent_at, Timex.Ecto.DateTime
    field :confirmed, :boolean, default: false
    field :deleted, :boolean, default: false

    field :password, Desqer.Type.String, virtual: true
    field :current_password, Desqer.Type.String, virtual: true

    timestamps()
  end
end
