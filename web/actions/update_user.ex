defmodule Desqer.Action.UpdateUser do
  import Ecto.Changeset

  def run(id, params) do
    get_user!(id) |> update(params)
  end

  defp get_user!(id) do
    Desqer.User |> Desqer.Repo.get!(id)
  end

  defp update(user, params) do
    user
    |> changeset(params)
    |> Desqer.Repo.update
  end

  defp changeset(user, params) do
    user
    |> cast(params, [:phone, :password, :current_password, :name, :email, :bio, :professional])
    |> validate_required([:current_password])
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &downcase/1)
    |> put_password_hash
    |> unique_constraint(:phone)
  end

  defp put_password_hash(%{changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Desqer.Password.hash(password))
  end

  defp put_password_hash(changeset), do: changeset

  defp downcase(value) when is_binary(value), do: String.downcase(value)
  defp downcase(_), do: nil
end