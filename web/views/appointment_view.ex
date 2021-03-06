defmodule Desqer.AppointmentView do
  use Desqer.Web, :view

  def render("index.json", %{appointments: appointments}) do
    rendered_appointments = render_many(appointments, Desqer.AppointmentView, "appointment.json")

    %{data: group_by_date(rendered_appointments)}
  end

  def render("show.json", %{appointment: appointment}) do
    %{data: %{appointment: render_one(appointment, Desqer.AppointmentView, "simple_appointment.json")}}
  end

  def render("show.json", %{appointments: appointments}) do
    %{data: %{appointments: render_many(appointments, Desqer.AppointmentView, "simple_appointment.json")}}
  end

  def render("simple_appointment.json", %{appointment: appointment}) do
    %{id: appointment.id,
      user_id: appointment.user_id,
      service_id: appointment.service_id,
      name: appointment.name,
      description: appointment.description,
      price: appointment.price,
      date: humanized_date(appointment.starts_at),
      starts_at: appointment.starts_at,
      ends_at: appointment.ends_at,
      notes: appointment.notes,
      status: appointment.status,
      owned: appointment.owned}
  end

  def render("appointment.json", %{appointment: appointment}) do
    %{id: appointment.id,
      user_id: appointment.user_id,
      service_id: appointment.service_id,
      professional_name: appointment.service.professional.user.name,
      venue_name: appointment.service.professional.venue.name,
      name: appointment.name,
      description: appointment.description,
      price: appointment.price,
      date: humanized_date(appointment.starts_at),
      starts_at: only_hours(appointment.starts_at),
      ends_at: only_hours(appointment.ends_at),
      notes: appointment.notes,
      status: appointment.status,
      owned: appointment.owned}
  end

  defp only_hours(datetime) do
    Timex.format! datetime, "%H:%M\h", :strftime
  end

  defp humanized_date(datetime) do
    Timex.format! datetime, "%Y-%m-%d", :strftime
  end

  defp group_by_date(appointments) do
    Enum.group_by(appointments, fn(appointment) -> appointment.date end)
  end
end
