defmodule Desqer.Assignment do
  use Desqer.Web, :model

  schema "assignments" do
    belongs_to :role, Desqer.Role
    belongs_to :service, Desqer.Service

    field :sunday, Desqer.Type.Hours
    field :monday, Desqer.Type.Hours
    field :tuesday, Desqer.Type.Hours
    field :wednesday, Desqer.Type.Hours
    field :thursday, Desqer.Type.Hours
    field :friday, Desqer.Type.Hours
    field :saturday, Desqer.Type.Hours
    field :deleted, :boolean, default: false

    timestamps()
  end
end
