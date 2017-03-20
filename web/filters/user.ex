defmodule Desqer.Filter.User do
  def get(phone) do
    case changeset = user_changeset(%{phone: phone}) do
      %{valid?: true} -> {:ok, get_user(phone)}
      %{valid?: false} -> {:error, changeset}
    end
  end

  defp user_changeset(params) do
    Ecto.Changeset.cast(%Desqer.User{}, params, [:phone])
  end

  defp get_user(phone) do
    Desqer.Repo.get_by!(Desqer.User, phone: phone)
  end
end
