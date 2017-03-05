defmodule Desqer.ServiceViewTest do
  use Desqer.ConnCase, async: true
  import Phoenix.View

  @service_attrs %{
    id: "123",
    professional_id: "456",
    name: "Hair Cut",
    description: "A better version of you.",
    price: 4200,
    duration: 30,
    in_advance: 1,
    status: "active",
    need_approval: false,
    online_scheduling: true,
    sunday: [],
    monday: ["13:00-20:00"],
    tuesday: ["13:00-20:00"],
    wednesday: ["13:00-20:00"],
    thursday: ["13:00-20:00"],
    friday: ["13:00-20:00"],
    saturday: [],
    deleted: false
  }

  test "renders show.json" do
    service = struct(Desqer.Service, @service_attrs)

    assert render(Desqer.ServiceView, "show.json", service: service) == %{data: %{service: @service_attrs}}
  end

  test "renders show.json with multiple services" do
    service = struct(Desqer.Service, @service_attrs)

    assert render(Desqer.ServiceView, "show.json", services: [service]) == %{data: %{services: [@service_attrs]}}
  end
end
