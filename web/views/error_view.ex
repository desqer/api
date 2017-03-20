defmodule Desqer.ErrorView do
  use Desqer.Web, :view

  def render("401.json", _assigns) do
    %{errors: %{detail: dgettext("errors", "Not authorized")}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: dgettext("errors", "Not found")}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: dgettext("errors", "Internal server error")}}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
