defmodule Desqer.Action.UpdateServiceTest do
  use Desqer.ModelCase, async: true

  test "raises error when service is not found on user owned venues" do
    professional = insert(:professional, owner: false)
    service = insert(:service, professional: professional)

    assert_raise Ecto.NoResultsError, fn ->
      Desqer.Action.UpdateService.run(service.professional.user, service.id, %{})
    end
  end

  test "returns error when required params are absent" do
    service = insert(:service, name: nil, description: nil, duration: nil, status: nil)
    {:error, changeset} = Desqer.Action.UpdateService.run(service.professional.user, service.id, %{})

    assert {:name, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:description, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:duration, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:status, {"can't be blank", [validation: :required]}} in changeset.errors
    refute changeset.valid?
  end

  test "updates service" do
    service = insert(:service)

    params = %{
      "name" => "Haircut Reloaded",
      "description" => "The hair style made for you.",
      "price" => 4200,
      "duration" => 30,
      "in_advance" => 5,
      "status" => :paused,
      "need_approval" => true,
      "online_scheduling" => false,
      "monday" => [{~T[13:00:00], ~T[17:00:00]}],
      "tuesday" => [{~T[08:00:00], ~T[12:00:00]}, {~T[13:00:00], ~T[17:00:00]}],
      "wednesday" => [{~T[08:00:00], ~T[12:00:00]}, {~T[13:00:00], ~T[17:00:00]}],
      "thursday" => [{~T[08:00:00], ~T[12:00:00]}, {~T[13:00:00], ~T[17:00:00]}],
      "friday" => [{~T[08:00:00], ~T[12:00:00]}]
    }

    {:ok, service} = Desqer.Action.UpdateService.run(service.professional.user, service.id, params)

    assert service.name == params["name"]
    assert service.description == params["description"]
    assert service.price == params["price"]
    assert service.duration == params["duration"]
    assert service.in_advance == params["in_advance"]
    assert service.status == params["status"]
    assert service.need_approval == params["need_approval"]
    assert service.online_scheduling == params["online_scheduling"]
    assert service.monday == params["monday"]
    assert service.tuesday == params["tuesday"]
    assert service.wednesday == params["wednesday"]
    assert service.thursday == params["thursday"]
    assert service.friday == params["friday"]
  end
end
