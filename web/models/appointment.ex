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

    timestamps()
  end

  def by_attendee(query, user_id) do
    from q in query,
    join: s in assoc(q, :service),
    join: r in assoc(s, :role),
    where: q.user_id == ^user_id,
    or_where: r.user_id == ^user_id
  end
end
