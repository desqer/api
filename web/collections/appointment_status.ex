defmodule Desqer.Collection.AppointmentStatus do
  use Desqer.Collection, [
    :pending,
    :active,
    :canceled
  ]
end
