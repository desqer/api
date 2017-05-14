defmodule Desqer.Action.CreateAppointmentTest do
  use Desqer.ModelCase, async: true

  test "raises error when service is not found" do
    user = insert(:user)

    assert_raise Ecto.NoResultsError, fn ->
      Desqer.Action.CreateAppointment.run(user, %{"service_id" => "59cdb0b8-21e1-4a78-ab6f-56cab8631536"})
    end
  end

  test "fetches default params from service" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service)

    {:error, changeset} = Desqer.Action.CreateAppointment.run(user, %{"service_id" => service.id})

    assert {:name, service.name} in changeset.changes
    assert {:description, service.description} in changeset.changes
    assert {:price, service.price} in changeset.changes
  end

  test "set status as pending when need approval" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service, need_approval: true)

    {:error, changeset} = Desqer.Action.CreateAppointment.run(user, %{"service_id" => service.id})

    assert {:status, Desqer.Collection.AppointmentStatus.pending} in changeset.changes
  end

  test "returns error when required params are absent" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service, name: nil, description: nil)

    {:error, changeset} = Desqer.Action.CreateAppointment.run(user, %{"service_id" => service.id})

    assert {:name, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:description, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:starts_at, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:ends_at, {"can't be blank", [validation: :required]}} in changeset.errors
    refute changeset.valid?
  end

  test "creates appointment" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service)

    params = %{
      "service_id" => service.id,
      "starts_at" => ~N[2017-03-01 09:00:00],
      "ends_at" => ~N[2017-03-01 09:30:00],
      "notes" => "Hair wash needed"
    }

    {:ok, appointment} = Desqer.Action.CreateAppointment.run(user, params)

    assert appointment.user_id == user.id
    assert appointment.service_id == service.id
    assert appointment.starts_at == Timex.to_datetime(params["starts_at"])
    assert appointment.ends_at == Timex.to_datetime(params["ends_at"])
    assert appointment.notes == params["notes"]
    assert appointment.status == Desqer.Collection.AppointmentStatus.active
  end
end
