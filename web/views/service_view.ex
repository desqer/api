defmodule Desqer.ServiceView do
  use Desqer.Web, :view

  def render("index.json", %{services: services}) do
    %{data: render_many(services, Desqer.ServiceView, "service.json")}
  end

  def render("show.json", %{service: service}) do
    %{data: %{service: render_one(service, Desqer.ServiceView, "service.json")}}
  end

  def render("show.json", %{services: services}) do
    %{data: %{services: render_many(services, Desqer.ServiceView, "service.json")}}
  end

  def render("service.json", %{service: service}) do
    %{id: service.id,
      professional_id: service.professional_id,
      name: service.name,
      description: service.description,
      price: service.price,
      duration: service.duration,
      in_advance: service.in_advance,
      status: service.status,
      need_approval: service.need_approval,
      online_scheduling: service.online_scheduling,
      sunday: dump_hours(service.sunday),
      monday: dump_hours(service.monday),
      tuesday: dump_hours(service.tuesday),
      wednesday: dump_hours(service.wednesday),
      thursday: dump_hours(service.thursday),
      friday: dump_hours(service.friday),
      saturday: dump_hours(service.saturday),
      deleted: service.deleted}
  end

  defp dump_hours(values) when is_list(values) do
    {:ok, hours} = Desqer.Type.Hours.dump(values)
    hours
  end

  defp dump_hours(_), do: []
end
