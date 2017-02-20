defmodule Desqer.LinkView do
  use Desqer.Web, :view

  def render("link.json", %{link: link}) do
    %{id: link.id,
      type: link.type,
      name: link.name,
      url: link.url,
      deleted: link.deleted}
  end
end
