defmodule Desqer.AppointmentView do
  use Desqer.Web, :view

  def render("show.json", %{appointment: appointment}) do
    %{data: %{appointment: render_one(appointment, Desqer.AppointmentView, "appointment.json")}}
  end

  def render("show.json", %{appointments: appointments}) do
    %{data: %{appointments: render_many(appointments, Desqer.AppointmentView, "appointment.json")}}
  end

  def render("appointment.json", %{appointment: appointment}) do
    %{id: appointment.id,
      user_id: appointment.user_id,
      service_id: appointment.service_id,
      name: appointment.name,
      description: appointment.description,
      price: appointment.price,
      starts_at: appointment.starts_at,
      ends_at: appointment.ends_at,
      notes: appointment.notes,
      status: appointment.status}
  end
end
