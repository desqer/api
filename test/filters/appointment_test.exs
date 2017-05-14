defmodule Desqer.Filter.AppointmentTest do
  use Desqer.ModelCase, async: true

  @starts_at Timex.shift(Timex.now, days: 2)
  @ends_at Timex.shift(@starts_at, hours: 1)

  test "lists future appointments by professional and customer user" do
    user = insert(:user, phone: "554799871234")
    other_user = insert(:user, phone: "554799872211")
    professional = insert(:professional, user: user)
    other_professional = insert(:professional, user: other_user)
    service = insert(:service, professional: professional)
    other_service = insert(:service, professional: other_professional)
    appointment = insert(:appointment, user: user, service: other_service, starts_at: @starts_at, ends_at: @ends_at)
    other_appointment = insert(:appointment, user: other_user, service: service, starts_at: @starts_at, ends_at: @ends_at)
    insert(:appointment, user: other_user, service: other_service, starts_at: @starts_at, ends_at: @ends_at)
    insert(:appointment, user: user, service: other_service)

    result = Desqer.Filter.Appointment.list(user, %{})
    result_ids = Enum.map(result, fn (r) -> r.id end)

    assert length(result) == 2
    assert appointment.id in result_ids
    assert other_appointment.id in result_ids
  end

  test "includes if it is owned by user" do
    appointment = insert(:appointment, starts_at: @starts_at, ends_at: @ends_at)

    [result] = Desqer.Filter.Appointment.list(appointment.user, %{})

    refute result.owned

    [result] = Desqer.Filter.Appointment.list(appointment.service.professional.user, %{})

    assert result.owned
  end

  test "#by_attendee" do
    user = insert(:user, phone: "554799871234")
    other_user = insert(:user, phone: "554799872211")
    professional = insert(:professional, user: user)
    other_professional = insert(:professional, user: other_user)
    service = insert(:service, professional: professional)
    other_service = insert(:service, professional: other_professional)
    appointment = insert(:appointment, user: user, service: other_service, starts_at: @starts_at, ends_at: @ends_at)
    other_appointment = insert(:appointment, user: other_user, service: service, starts_at: @starts_at, ends_at: @ends_at)
    insert(:appointment, user: other_user, service: other_service, starts_at: @starts_at, ends_at: @ends_at)

    result = Desqer.Filter.Appointment.by_attendee(Desqer.Appointment, user.id) |> Desqer.Repo.all
    result_ids = Enum.map(result, fn (r) -> r.id end)

    assert length(result) == 2
    assert appointment.id in result_ids
    assert other_appointment.id in result_ids
  end

  test "#in_future" do
    user = insert(:user, phone: "554799871234")
    professional = insert(:professional, user: user)
    service = insert(:service, professional: professional)
    appointment = insert(:appointment, user: user, service: service, starts_at: @starts_at, ends_at: @ends_at)
    insert(:appointment, user: user, service: service)

    [result] = Desqer.Filter.Appointment.in_future(Desqer.Appointment) |> Desqer.Repo.all

    assert result.id == appointment.id
  end
end
