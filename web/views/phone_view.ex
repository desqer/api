defmodule Desqer.PhoneView do
  use Desqer.Web, :view

  def render("phone.json", %{phone: phone}) do
    %{id: phone.id,
      type: phone.type,
      value: phone.value.full_number,
      deleted: phone.deleted}
  end
end
