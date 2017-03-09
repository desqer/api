defmodule Desqer.Filter.Service do
  import Ecto.Query

  def by_professional(query, user_id) do
    from q in query,
    join: p in assoc(q, :professional),
    where: p.user_id == ^user_id
  end

  def by_venue_owner(query, user_id) do
    from q in query,
    distinct: true,
    join: p in assoc(q, :professional),
    join: v in assoc(p, :venue),
    join: vr in assoc(v, :professionals),
    where: vr.user_id == ^user_id,
    where: vr.owner == true
  end
end
