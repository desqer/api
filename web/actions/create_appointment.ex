defmodule Desqer.Action.CreateAppointment do
  import Ecto.Changeset

  def run(user, %{"service_id" => service_id} = params) do
    service_id
    |> get_service!
    |> fetch_service(params)
    |> Map.put("user_id", user.id)
    |> appointment_changeset
    |> Desqer.Repo.insert
  end

  defp appointment_changeset(params) do
    permitted_params = [:user_id, :service_id, :name, :description, :price, :starts_at, :ends_at, :notes, :status]
    required_params = [:user_id, :service_id, :name, :description, :starts_at, :ends_at, :status]

    %Desqer.Appointment{}
    |> cast(params, permitted_params)
    |> validate_required(required_params)
  end

  defp fetch_service(service, params) do
    Map.merge params, %{
      "name" => service.name,
      "description" => service.description,
      "price" => service.price,
      "status" => status_for(service.need_approval)
    }
  end

  defp status_for(need_approval) do
    if need_approval,
    do: Desqer.Collection.AppointmentStatus.pending,
    else: Desqer.Collection.AppointmentStatus.active
  end

  defp get_service!(service_id) do
    Desqer.Repo.get!(Desqer.Service, service_id)
  end
end
