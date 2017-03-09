defmodule Desqer.Action.UpdateAppointment do
  import Ecto.Changeset

  def run(user, appointment_id, params) do
    user
    |> get_appointment!(appointment_id)
    |> appointment_changeset(params)
    |> Desqer.Repo.update
  end

  defp appointment_changeset(appointment, params) do
    appointment
    |> cast(params, [:starts_at, :ends_at, :notes, :status])
    |> validate_required([:starts_at, :ends_at, :status])
  end

  defp get_appointment!(user, appointment_id) do
    Desqer.Appointment
    |> Desqer.Filter.Appointment.by_attendee(user.id)
    |> Desqer.Repo.get!(appointment_id)
  end
end
