defmodule Desqer.Action.CreateAppointmentByProfessionalTest do
  use Desqer.ModelCase, async: true

  test "raises error when service is not found" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service)

    assert_raise Ecto.NoResultsError, fn ->
      Desqer.Action.CreateAppointmentByProfessional.run(user, [], %{"service_id" => service.id})
    end
  end

  test "returns empty without user_ids" do
    service = insert(:service)

    {:ok, appointments} = Desqer.Action.CreateAppointmentByProfessional.run(service.professional.user, [], %{"service_id" => service.id})

    assert appointments == %{}
  end

  test "fetches default params from service" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service)

    {:error, _, changeset, _} = Desqer.Action.CreateAppointmentByProfessional.run(service.professional.user, [user.id], %{"service_id" => service.id})

    assert {:name, service.name} in changeset.changes
    assert {:description, service.description} in changeset.changes
    assert {:price, service.price} in changeset.changes
  end

  test "set status as pending when need approval" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service, need_approval: true)

    {:error, _, changeset, _} = Desqer.Action.CreateAppointmentByProfessional.run(service.professional.user, [user.id], %{"service_id" => service.id})

    assert {:status, Desqer.Collection.AppointmentStatus.pending} in changeset.changes
  end

  test "returns error when required params are absent" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service, name: nil, description: nil)

    {:error, _, changeset, _} = Desqer.Action.CreateAppointmentByProfessional.run(service.professional.user, [user.id], %{"service_id" => service.id})

    assert {:name, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:description, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:starts_at, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:ends_at, {"can't be blank", [validation: :required]}} in changeset.errors
    refute changeset.valid?
  end

  test "returns error when relations does not exist" do
    service = insert(:service)
    invalid_user_id = "11111111-1111-1111-1111-111111111111"
    params = %{
      "service_id" => service.id,
      "starts_at" => ~N[2017-03-01 09:00:00],
      "ends_at" => ~N[2017-03-01 09:30:00]
    }

    {:error, _, changeset, _} = Desqer.Action.CreateAppointmentByProfessional.run(service.professional.user, [invalid_user_id], params)

    assert {:user_id, {"does not exist", []}} in changeset.errors
    refute changeset.valid?
  end

  test "creates appointments" do
    user = insert(:user, phone: "554799871234")
    service = insert(:service)

    params = %{
      "service_id" => service.id,
      "name" => "Super Haircut",
      "description" => "An awsome hair style",
      "price" => 2700,
      "starts_at" => ~N[2017-03-01 09:00:00],
      "ends_at" => ~N[2017-03-01 09:30:00],
      "notes" => "Hair wash bonus"
    }

    {:ok, %{appointment_0: appointment}} = Desqer.Action.CreateAppointmentByProfessional.run(service.professional.user, [user.id], params)

    assert appointment.user_id == user.id
    assert appointment.service_id == service.id
    assert appointment.name == params["name"]
    assert appointment.description == params["description"]
    assert appointment.price == params["price"]
    assert appointment.starts_at == Timex.to_datetime(params["starts_at"])
    assert appointment.ends_at == Timex.to_datetime(params["ends_at"])
    assert appointment.notes == params["notes"]
    assert appointment.status == Desqer.Collection.AppointmentStatus.active
  end
end
