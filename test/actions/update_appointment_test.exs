defmodule Desqer.Action.UpdateAppointmentTest do
  use Desqer.ModelCase, async: true

  test "raises error when appointment is not found for user or professional" do
    user = insert(:user, phone: "554799871234")
    appointment = insert(:appointment)

    assert_raise Ecto.NoResultsError, fn ->
      Desqer.Action.UpdateAppointment.run(user, appointment.id, %{})
    end
  end

  test "returns error when required params are absent" do
    appointment = insert(:appointment, starts_at: nil, ends_at: nil, status: nil)
    {:error, changeset} = Desqer.Action.UpdateAppointment.run(appointment.user, appointment.id, %{})

    assert {:starts_at, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:ends_at, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:status, {"can't be blank", [validation: :required]}} in changeset.errors
    refute changeset.valid?
  end

  test "updates appointment" do
    appointment = insert(:appointment)

    params = %{
      "starts_at" => %Ecto.DateTime{year: 2017, month: 3, day: 1, hour: 9, min: 0, sec: 0},
      "ends_at" => %Ecto.DateTime{year: 2017, month: 3, day: 1, hour: 9, min: 30, sec: 0},
      "status" => Desqer.Collection.AppointmentStatus.canceled
    }

    {:ok, appointment} = Desqer.Action.UpdateAppointment.run(appointment.user, appointment.id, params)

    assert appointment.starts_at == params["starts_at"]
    assert appointment.ends_at == params["ends_at"]
    assert appointment.status == params["status"]
  end
end
