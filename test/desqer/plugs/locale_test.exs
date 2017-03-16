defmodule Desqer.Plug.LocaleTest do
  use Desqer.ConnCase, async: true

  test "#call", %{conn: conn} do
    Desqer.Plug.Locale.call(conn, "pt_BR")

    assert Gettext.get_locale(Desqer.Gettext) == "pt_BR"
  end

  test "#call with header", %{conn: conn} do
    conn = put_req_header(conn, "accept-language", "es_AR")

    Desqer.Plug.Locale.call(conn, "pt_BR")

    assert Gettext.get_locale(Desqer.Gettext) == "es_AR"
  end
end
