defmodule Desqer.GuardianSerializer do
  import Ecto.Query, only: [from: 2]

  @behaviour Guardian.Serializer

  def for_token(%Desqer.Session{} = session), do: {:ok, "Session:#{session.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("Session:" <> id), do: {:ok, fetch_session(id)}
  def from_token(_), do: {:error, "Unknown resource type"}

  defp fetch_session(id) do
    id
    |> session_query
    |> Desqer.Repo.one
  end

  defp session_query(id) do
    from s in Desqer.Session,
      preload: [:user],
      where: s.id == ^id and
             s.revoked == false
  end
end
