defmodule Desqer.AppointmentTest do
  use Desqer.ModelCase, async: true

  test "#by_attendee" do
    user = insert(:user, phone: "554799871234")
    other_user = insert(:user, phone: "554799872211")
    role = insert(:role, user: user)
    other_role = insert(:role, user: other_user)
    service = insert(:service, role: role)
    other_service = insert(:service, role: other_role)
    appointment = insert(:appointment, user: user, service: other_service)
    other_appointment = insert(:appointment, user: other_user, service: service)
    insert(:appointment, user: other_user, service: other_service)

    result = Desqer.Appointment.by_attendee(Desqer.Appointment, user.id) |> Desqer.Repo.all
    result_ids = Enum.map(result, fn (r) -> r.id end)

    assert length(result) == 2
    assert appointment.id in result_ids
    assert other_appointment.id in result_ids
  end
end
