defmodule Desqer.Service do
  use Desqer.Web, :model

  schema "services" do
    belongs_to :role, Desqer.Role

    field :name, :string
    field :description, :string
    field :price, :integer
    field :duration, :integer
    field :in_advance, :integer
    field :sunday, Desqer.Type.Hours
    field :monday, Desqer.Type.Hours
    field :tuesday, Desqer.Type.Hours
    field :wednesday, Desqer.Type.Hours
    field :thursday, Desqer.Type.Hours
    field :friday, Desqer.Type.Hours
    field :saturday, Desqer.Type.Hours
    field :status, Desqer.Collection.ServiceStatus
    field :need_approval, :boolean, default: false
    field :online_scheduling, :boolean, default: true
    field :deleted, :boolean, default: false

    timestamps()
  end

  def by_venue_owner(query, user_id) do
    from q in query,
    distinct: true,
    join: r in assoc(q, :role),
    join: v in assoc(r, :venue),
    join: vr in assoc(v, :roles),
    where: vr.user_id == ^user_id,
    where: vr.owner == true
  end
end
