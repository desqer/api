defmodule Desqer.AppointmentViewTest do
  use Desqer.ConnCase, async: true
  import Phoenix.View

  @appointment_attrs %{
    id: "123",
    user_id: "456",
    service_id: "789",
    name: "Hair Cut",
    description: "A better version of you.",
    price: 4200,
    date: "2017-03-12",
    starts_at: ~N[2017-03-12 14:30:00],
    ends_at: ~N[2017-03-12 15:00:00],
    notes: "You'll gonna love it",
    status: "active",
    owned: true
  }

  # test "renders index.json" do
  #   appointment = struct(Desqer.Appointment, @appointment_attrs)
  #
  #   assert render(Desqer.AppointmentView, "index.json", appointments: [appointment]) == %{data: %{"2017-03-12" => [@appointment_attrs]}}
  # end

  test "renders show.json" do
    appointment = struct(Desqer.Appointment, @appointment_attrs)

    assert render(Desqer.AppointmentView, "show.json", appointment: appointment) == %{data: %{appointment: @appointment_attrs}}
  end

  test "renders show.json with multiple appointments" do
    appointment = struct(Desqer.Appointment, @appointment_attrs)

    assert render(Desqer.AppointmentView, "show.json", appointments: [appointment]) == %{data: %{appointments: [@appointment_attrs]}}
  end
end
