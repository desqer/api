defmodule Desqer.Action.CreateService do
  import Ecto.Changeset

  def run(user, professional_ids, params) do
    Ecto.Multi.new
    |> ensure_professionals_owner(professional_ids, user)
    |> build_multi_services(professional_ids, params)
    |> Desqer.Repo.transaction
  end

  defp build_multi_services(multi, professional_ids, params) do
    Enum.reduce(professional_ids, multi, &build_multi_service(&1, &2, params))
  end

  defp build_multi_service(professional_id, multi, params) do
    service_params = Map.put(params, "professional_id", professional_id)

    Ecto.Multi.insert(multi, :"service_#{length(multi.operations)}", service_changeset(service_params))
  end

  defp service_changeset(params) do
    permitted_params = [:professional_id, :name, :description, :price, :duration,
     :in_advance, :status, :need_approval, :online_scheduling, :sunday, :monday,
     :tuesday, :wednesday, :thursday, :friday, :saturday]

    %Desqer.Service{}
    |> cast(params, permitted_params)
    |> validate_required([:professional_id, :name, :description, :duration, :status])
  end

  defp ensure_professionals_owner(multi, professional_ids, user) do
    if Enum.all?(professional_ids, &professional_owner?(&1, user.id)),
    do: multi,
    else: Ecto.Multi.error(multi, :user, user_changeset(user))
  end

  defp user_changeset(user) do
    user |> change |> add_error(:professional_id, "not authorized")
  end

  defp professional_owner?(professional_id, user_id) do
    Desqer.Professional
    |> Desqer.Filter.Professional.by_id(professional_id)
    |> Desqer.Filter.Professional.by_owner(user_id)
    |> Desqer.Repo.exists?
  end
end
