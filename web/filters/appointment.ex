defmodule Desqer.Filter.Appointment do
  import Ecto.Query

  def list(user, _params) do
    Desqer.Appointment
    |> by_attendee(user.id)
    |> in_future
    |> order_by_date
    |> with_service_info
    |> Desqer.Repo.all
  end

  def by_attendee(query, user_id) do
    from q in query,
    join: s in assoc(q, :service),
    join: p in assoc(s, :professional),
    where: q.user_id == ^user_id,
    or_where: p.user_id == ^user_id,
    select: %{q | owned: p.user_id == ^user_id}
  end

  def in_future(query) do
    from q in query,
    where: q.starts_at >= ^DateTime.utc_now
  end

  def order_by_date(query) do
    from q in query,
    order_by: q.starts_at
  end

  def with_service_info(query) do
    from q in query,
    preload: [service: [professional: [:user, :venue]]]
  end
end
