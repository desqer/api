defmodule Desqer.Appointment do
  use Desqer.Web, :model

  schema "appointments" do
    belongs_to :user, Desqer.User
    belongs_to :service, Desqer.Service

    field :name, :string
    field :description, :string
    field :price, :integer
    field :starts_at, Ecto.DateTime
    field :ends_at, Ecto.DateTime
    field :notes, :string
    field :status, Desqer.Collection.AppointmentStatus

    field :owned, :boolean, virtual: true

    timestamps()
  end
end
