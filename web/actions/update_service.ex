defmodule Desqer.Action.UpdateService do
  import Ecto.Changeset

  def run(user, id, params) do
    user
    |> get_service!(id)
    |> service_changeset(params)
    |> Desqer.Repo.update
  end

  defp service_changeset(service, params) do
    permitted_params = [:name, :description, :price, :duration, :in_advance, :status,
      :need_approval, :online_scheduling, :sunday, :monday, :tuesday, :wednesday,
      :thursday, :friday, :saturday]

    service
    |> cast(params, permitted_params)
    |> validate_required([:name, :description, :duration, :status])
  end

  defp get_service!(user, id) do
    Desqer.Service
    |> Desqer.Service.by_venue_owner(user.id)
    |> Desqer.Repo.get!(id)
  end
end
