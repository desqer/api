defmodule Desqer.Action.CreateAppointmentTest do
  use Desqer.ModelCase, async: true

  test "raises error when service is not found for professional" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service)

    assert_raise Ecto.NoResultsError, fn ->
      Desqer.Action.CreateAppointment.run(user, [], %{"service_id" => service.id})
    end
  end

  test "raises error when service is not found" do
    user = insert(:user)

    assert_raise Ecto.NoResultsError, fn ->
      Desqer.Action.CreateAppointment.run(user, %{"service_id" => "59cdb0b8-21e1-4a78-ab6f-56cab8631536"})
    end
  end

  test "returns empty without user_ids" do
    service = insert(:service)

    {:ok, appointments} = Desqer.Action.CreateAppointment.run(service.role.user, [], %{"service_id" => service.id})

    assert appointments == %{}
  end

  test "fetches default params from service for professional" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service)

    {:error, _, changeset, _} = Desqer.Action.CreateAppointment.run(service.role.user, [user.id], %{"service_id" => service.id})

    assert {:name, service.name} in changeset.changes
    assert {:description, service.description} in changeset.changes
    assert {:price, service.price} in changeset.changes
  end

  test "fetches default params from service" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service)

    {:error, changeset} = Desqer.Action.CreateAppointment.run(user, %{"service_id" => service.id})

    assert {:name, service.name} in changeset.changes
    assert {:description, service.description} in changeset.changes
    assert {:price, service.price} in changeset.changes
  end

  test "set status as pending when need approval for professional" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service, need_approval: true)

    {:error, _, changeset, _} = Desqer.Action.CreateAppointment.run(service.role.user, [user.id], %{"service_id" => service.id})

    assert {:status, Desqer.Collection.AppointmentStatus.pending} in changeset.changes
  end

  test "set status as pending when need approval" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service, need_approval: true)

    {:error, changeset} = Desqer.Action.CreateAppointment.run(user, %{"service_id" => service.id})

    assert {:status, Desqer.Collection.AppointmentStatus.pending} in changeset.changes
  end

  test "returns error when required params are absent for professional" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service, name: nil, description: nil)

    {:error, _, changeset, _} = Desqer.Action.CreateAppointment.run(service.role.user, [user.id], %{"service_id" => service.id})

    assert {:name, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:description, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:starts_at, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:ends_at, {"can't be blank", [validation: :required]}} in changeset.errors
    refute changeset.valid?
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

  test "creates appointment for professional" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service)

    params = %{
      "service_id" => service.id,
      "name" => "Super Haircut",
      "description" => "An awsome hair style",
      "price" => 2700,
      "starts_at" => %Ecto.DateTime{year: 2017, month: 3, day: 1, hour: 9, min: 0, sec: 0},
      "ends_at" => %Ecto.DateTime{year: 2017, month: 3, day: 1, hour: 9, min: 30, sec: 0},
      "notes" => "Hair wash bonus"
    }

    {:ok, %{appointment_0: appointment}} = Desqer.Action.CreateAppointment.run(service.role.user, [user.id], params)

    assert appointment.user_id == user.id
    assert appointment.service_id == service.id
    assert appointment.name == params["name"]
    assert appointment.description == params["description"]
    assert appointment.price == params["price"]
    assert appointment.starts_at == params["starts_at"]
    assert appointment.ends_at == params["ends_at"]
    assert appointment.notes == params["notes"]
    assert appointment.status == Desqer.Collection.AppointmentStatus.active
  end

  test "creates appointment" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service)

    params = %{
      "service_id" => service.id,
      "name" => "Super Haircut",
      "description" => "An awsome hair style",
      "price" => 2700,
      "starts_at" => %Ecto.DateTime{year: 2017, month: 3, day: 1, hour: 9, min: 0, sec: 0},
      "ends_at" => %Ecto.DateTime{year: 2017, month: 3, day: 1, hour: 9, min: 30, sec: 0},
      "notes" => "Hair wash bonus"
    }

    {:ok, appointment} = Desqer.Action.CreateAppointment.run(user, params)

    assert appointment.user_id == user.id
    assert appointment.service_id == service.id
    assert appointment.name == params["name"]
    assert appointment.description == params["description"]
    assert appointment.price == params["price"]
    assert appointment.starts_at == params["starts_at"]
    assert appointment.ends_at == params["ends_at"]
    assert appointment.notes == params["notes"]
    assert appointment.status == Desqer.Collection.AppointmentStatus.active
  end
end
