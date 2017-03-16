defmodule Desqer.Plug.Locale do
  import Plug.Conn

  def init(default), do: default

  def call(conn, default) do
    locale = accept_language(conn) || default

    Gettext.put_locale(Desqer.Gettext, locale)

    put_resp_header(conn, "content-language", locale)
  end

  defp accept_language(conn) do
    get_req_header(conn, "accept-language") |> List.first
  end
end
