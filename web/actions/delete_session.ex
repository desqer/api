defmodule Desqer.Action.DeleteSession do
  import Ecto.Changeset

  def run(session) do
    session
    |> change(revoked: true)
    |> Desqer.Repo.update
  end
end
