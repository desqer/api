defmodule Desqer.Filter.Professional do
  import Ecto.Query

  def by_id(query, id) do
    from q in query,
    where: q.id == ^id
  end

  def by_owner(query, user_id) do
    from q in query,
    distinct: true,
    join: v in assoc(q, :venue),
    join: vp in assoc(v, :professionals),
    where: vp.user_id == ^user_id,
    where: vp.owner == true
  end
end
