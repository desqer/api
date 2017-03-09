defmodule Desqer.Filter.Appointment do
  import Ecto.Query

  def list(user, _params) do
    Desqer.Appointment
    |> by_attendee(user.id)
    |> Desqer.Repo.all
  end

  defp by_attendee(query, user_id) do
    from q in query,
    join: s in assoc(q, :service),
    join: p in assoc(s, :professional),
    where: q.user_id == ^user_id,
    or_where: p.user_id == ^user_id
  end
end
