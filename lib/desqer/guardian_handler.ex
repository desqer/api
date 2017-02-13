defmodule Desqer.GuardianHandler do
  use Phoenix.Controller

  def unauthenticated(conn, _params) do
    render_unauthorized(conn)
  end

  def no_resource(conn, _params) do
    render_unauthorized(conn)
  end

  defp render_unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> put_view(Desqer.ErrorView)
    |> render("401.json")
    |> halt
  end
end
