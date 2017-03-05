defmodule Desqer.Action.CreateServiceTest do
  use Desqer.ModelCase, async: true

  test "returns empty without professional_ids" do
    professional = insert(:professional)

    {:ok, services} = Desqer.Action.CreateService.run(professional.user, [], %{})

    assert services == %{}
  end

  test "returns error when required params are absent" do
    professional = insert(:professional)
    {:error, _, changeset, _} = Desqer.Action.CreateService.run(professional.user, [professional.id], %{})

    assert {:name, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:description, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:duration, {"can't be blank", [validation: :required]}} in changeset.errors
    assert {:status, {"can't be blank", [validation: :required]}} in changeset.errors
    refute changeset.valid?
  end

  test "returns error when professional does not belong to user owned venues" do
    professional = insert(:professional, owner: false)
    params = %{"name" => "Haircut", "description" => "Best haircut in the world", "duration" => 30, "status" => "active"}

    {:error, _, changeset, _} = Desqer.Action.CreateService.run(professional.user, [professional.id], params)

    assert {:professional_id,  {"not authorized", []}} in changeset.errors
    refute changeset.valid?
  end

  test "creates service for professionals" do
    professional = insert(:professional)

    params = %{
      "name" => "Haircut Reloaded",
      "description" => "The hair style made for you.",
      "price" => 4200,
      "duration" => 30,
      "in_advance" => 5,
      "status" => :active,
      "need_approval" => false,
      "online_scheduling" => true,
      "monday" => [{~T[13:00:00], ~T[18:00:00]}],
      "tuesday" => [{~T[08:00:00], ~T[12:00:00]}, {~T[13:00:00], ~T[18:00:00]}],
      "wednesday" => [{~T[08:00:00], ~T[12:00:00]}, {~T[13:00:00], ~T[18:00:00]}],
      "thursday" => [{~T[08:00:00], ~T[12:00:00]}, {~T[13:00:00], ~T[18:00:00]}],
      "friday" => [{~T[08:00:00], ~T[12:00:00]}]
    }

    {:ok, %{service_0: service}} = Desqer.Action.CreateService.run(professional.user, [professional.id], params)

    assert service.professional_id == professional.id
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
