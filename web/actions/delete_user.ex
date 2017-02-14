defmodule Desqer.Action.DeleteUser do
  import Ecto.Changeset

  def run(user) do
    user
    |> change(deleted: true)
    |> Desqer.Repo.update
  end
end
