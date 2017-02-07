defmodule Desqer.Action.DeleteUser do
  import Ecto.Changeset

  def run(id) do
    get_user!(id) |> delete
  end

  defp get_user!(id) do
    Desqer.User |> Desqer.Repo.get!(id)
  end

  defp delete(user) do
    user
    |> change(deleted: true)
    |> Desqer.Repo.update
  end
end
