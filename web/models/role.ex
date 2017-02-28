defmodule Desqer.Role do
  use Desqer.Web, :model

  schema "roles" do
    belongs_to :user, Desqer.User
    belongs_to :venue, Desqer.Venue

    has_many :services, Desqer.Service

    field :name, :string
    field :owner, :boolean, default: false
    field :deleted, :boolean, default: false

    timestamps()
  end

  def by_id(query, id) do
    from q in query,
    where: q.id == ^id
  end

  def by_owner(query, user_id) do
    from q in query,
    distinct: true,
    join: v in assoc(q, :venue),
    join: vr in assoc(v, :roles),
    where: vr.user_id == ^user_id,
    where: vr.owner == true
  end
end
