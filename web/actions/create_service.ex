defmodule Desqer.Action.CreateService do
  import Ecto.Changeset

  def run(user, role_ids, params) do
    Ecto.Multi.new
    |> ensure_roles_owner(role_ids, user)
    |> build_multi_services(role_ids, params)
    |> Desqer.Repo.transaction
  end

  defp build_multi_services(multi, role_ids, params) do
    Enum.reduce(role_ids, multi, &build_multi_service(&1, &2, params))
  end

  defp build_multi_service(role_id, multi, params) do
    service_params = Map.put(params, "role_id", role_id)

    Ecto.Multi.insert(multi, :"service_#{length(multi.operations)}", service_changeset(service_params))
  end

  defp service_changeset(params) do
    permitted_params = [:role_id, :name, :description, :price, :duration,
     :in_advance, :status, :need_approval, :online_scheduling, :sunday, :monday,
     :tuesday, :wednesday, :thursday, :friday, :saturday]

    %Desqer.Service{}
    |> cast(params, permitted_params)
    |> validate_required([:role_id, :name, :description, :duration, :status])
  end

  defp ensure_roles_owner(multi, role_ids, user) do
    if Enum.all?(role_ids, &role_owner?(&1, user.id)),
    do: multi,
    else: Ecto.Multi.error(multi, :user, user_changeset(user))
  end

  defp user_changeset(user) do
    user |> change |> add_error(:role_id, "not authorized")
  end

  defp role_owner?(role_id, user_id) do
    Desqer.Role
    |> Desqer.Role.by_id(role_id)
    |> Desqer.Role.by_owner(user_id)
    |> Desqer.Repo.exists?
  end
end
