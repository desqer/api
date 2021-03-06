defmodule Desqer.ErrorViewTest do
  use Desqer.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 401.json" do
    assert render(Desqer.ErrorView, "401.json", []) ==
           %{errors: %{detail: "Not authorized"}}
  end

  test "renders 404.json" do
    assert render(Desqer.ErrorView, "404.json", []) ==
           %{errors: %{detail: "Not found"}}
  end

  test "render 500.json" do
    assert render(Desqer.ErrorView, "500.json", []) ==
           %{errors: %{detail: "Internal server error"}}
  end

  test "render any other" do
    assert render(Desqer.ErrorView, "505.json", []) ==
           %{errors: %{detail: "Internal server error"}}
  end
end
