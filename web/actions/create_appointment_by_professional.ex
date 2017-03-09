defmodule Desqer.Action.CreateAppointmentByProfessional do
  import Ecto.Changeset

  def run(user, user_ids, %{"service_id" => service_id} = params) do
    user
    |> get_service!(service_id)
    |> fetch_service(params)
    |> insert_appointments(user_ids)
  end

  defp insert_appointments(params, user_ids) do
    Ecto.Multi.new
    |> build_multi_appointments(user_ids, params)
    |> Desqer.Repo.transaction
  end

  defp build_multi_appointments(multi, user_ids, params) do
    Enum.reduce(user_ids, multi, &build_multi_appointment(&1, &2, params))
  end

  defp build_multi_appointment(user_id, multi, params) do
    params = Map.put(params, "user_id", user_id)

    Ecto.Multi.insert(multi, :"appointment_#{length(multi.operations)}", appointment_changeset(params))
  end

  defp appointment_changeset(params) do
    permitted_params = [:user_id, :service_id, :name, :description, :price, :starts_at, :ends_at, :notes, :status]
    required_params = [:user_id, :service_id, :name, :description, :starts_at, :ends_at, :status]

    %Desqer.Appointment{}
    |> cast(params, permitted_params)
    |> validate_required(required_params)
    |> foreign_key_constraint(:user_id)
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

  defp get_service!(user, service_id) do
    Desqer.Service
    |> Desqer.Filter.Service.by_professional(user.id)
    |> Desqer.Repo.get!(service_id)
  end
end
