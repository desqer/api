defmodule Desqer.Filter.AppointmentTest do
  use Desqer.ModelCase, async: true

  test "lists appointments by professional and customer user" do
    user = insert(:user, phone: "554799871234")
    other_user = insert(:user, phone: "554799872211")
    professional = insert(:professional, user: user)
    other_professional = insert(:professional, user: other_user)
    service = insert(:service, professional: professional)
    other_service = insert(:service, professional: other_professional)
    appointment = insert(:appointment, user: user, service: other_service)
    other_appointment = insert(:appointment, user: other_user, service: service)
    insert(:appointment, user: other_user, service: other_service)

    result = Desqer.Filter.Appointment.list(user, %{})
    result_ids = Enum.map(result, fn (r) -> r.id end)

    assert length(result) == 2
    assert appointment.id in result_ids
    assert other_appointment.id in result_ids
  end

  test "#by_attendee" do
    user = insert(:user, phone: "554799871234")
    other_user = insert(:user, phone: "554799872211")
    professional = insert(:professional, user: user)
    other_professional = insert(:professional, user: other_user)
    service = insert(:service, professional: professional)
    other_service = insert(:service, professional: other_professional)
    appointment = insert(:appointment, user: user, service: other_service)
    other_appointment = insert(:appointment, user: other_user, service: service)
    insert(:appointment, user: other_user, service: other_service)

    result = Desqer.Filter.Appointment.by_attendee(Desqer.Appointment, user.id) |> Desqer.Repo.all
    result_ids = Enum.map(result, fn (r) -> r.id end)

    assert length(result) == 2
    assert appointment.id in result_ids
    assert other_appointment.id in result_ids
  end
end
