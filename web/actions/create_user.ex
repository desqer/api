defmodule Desqer.Action.CreateUser do
  import Ecto.Changeset

  def run(params) do
    insert(params)
  end

  defp insert(params) do
    %Desqer.User{}
    |> changeset(params)
    |> Desqer.Repo.insert
  end

  defp changeset(user, params) do
    user
    |> cast(params, [:name, :phone, :password])
    |> validate_required([:name, :phone, :password])
    |> validate_length(:password, min: 6)
    |> put_password_hash
    |> unique_constraint(:phone)
  end

  defp put_password_hash(%{changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Desqer.Password.hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
