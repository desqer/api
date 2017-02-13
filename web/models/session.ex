defmodule Desqer.Session do
  use Desqer.Web, :model

  schema "sessions" do
    belongs_to :user, Desqer.User

    # TODO: incluir o type user_agent
    field :user_agent, :string
    field :remote_ip, Desqer.Type.IP
    field :revoked, :boolean, default: false

    field :phone, Desqer.Type.Phone, virtual: true
    field :password, :string, virtual: true

    timestamps()
  end
end
