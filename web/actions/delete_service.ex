defmodule Desqer.Action.DeleteService do
  import Ecto.Changeset

  def run(user, id) do
    user
    |> get_service!(id)
    |> change(deleted: true)
    |> Desqer.Repo.update
  end

  defp get_service!(user, id) do
    Desqer.Service
    |> Desqer.Service.by_venue_owner(user.id)
    |> Desqer.Repo.get!(id)
  end
end
