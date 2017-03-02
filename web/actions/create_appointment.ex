defmodule Desqer.Action.CreateAppointment do
  import Ecto.Changeset

  def run(user, user_ids, %{"service_id" => service_id} = params) do
    params = user |> get_service!(service_id) |> fetch_service(params)

    Ecto.Multi.new
    |> build_multi_appointments(user_ids, params)
    |> Desqer.Repo.transaction
  end

  def run(user, %{"service_id" => service_id} = params) do
    service_id
    |> get_service!
    |> fetch_service(params)
    |> Map.put("user_id", user.id)
    |> appointment_changeset
    |> Desqer.Repo.insert
  end

  defp build_multi_appointments(multi, user_ids, params) do
    Enum.reduce(user_ids, multi, &build_multi_appointment(&1, &2, params))
  end

  defp build_multi_appointment(user_id, multi, params) do
    params = Map.put(params, "user_id", user_id)

    Ecto.Multi.insert(multi, :"appointment_#{length(multi.operations)}", appointment_changeset(params))
  end

  defp appointment_changeset(params) do
    permitted_params = [:user_id, :service_id, :name, :description, :price,
     :starts_at, :ends_at, :notes, :status]

    %Desqer.Appointment{}
    |> cast(params, permitted_params)
    |> validate_required([:user_id, :service_id, :name, :description, :starts_at, :ends_at, :status])
  end

  defp fetch_service(service, params) do
    default_params = %{
      "name" => service.name,
      "description" => service.description,
      "price" => service.price,
      "status" => status_for(service.need_approval)
    }

    Map.merge(default_params, params)
  end

  defp status_for(need_approval) do
    if need_approval,
    do: Desqer.Collection.AppointmentStatus.pending,
    else: Desqer.Collection.AppointmentStatus.active
  end

  defp get_service!(service_id) do
    Desqer.Repo.get!(Desqer.Service, service_id)
  end

  defp get_service!(user, service_id) do
    Desqer.Service
    |> Desqer.Service.by_role(user.id)
    |> Desqer.Repo.get!(service_id)
  end
end
