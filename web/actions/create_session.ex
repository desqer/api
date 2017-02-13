defmodule Desqer.Action.CreateSession do
  import Ecto.Changeset

  def run(params, user_agent, remote_ip) do
    insert(params, user_agent, remote_ip) |> sign_in
  end

  defp insert(params, user_agent, remote_ip) do
    %Desqer.Session{}
    |> changeset(params)
    |> put_change(:user_agent, user_agent)
    |> put_change(:remote_ip, remote_ip)
    |> Desqer.Repo.insert
  end

  defp changeset(session, params) do
    session
    |> cast(params, [:phone, :password])
    |> validate_required([:phone, :password])
    |> get_user
    |> authenticate
  end

  defp get_user(%{changes: %{phone: phone}} = changeset) do
    case Desqer.Repo.get_by(Desqer.User, phone: phone) do
      nil  -> add_error(changeset, :user, "not authorized")
      user -> put_assoc(changeset, :user, user)
    end
  end

  defp get_user(changeset), do: changeset

  defp authenticate(%{changes: %{user: %{data: user}, password: password}} = changeset) do
    case Desqer.Password.check(password, user.password_hash) do
      false -> add_error(changeset, :user, "not authorized")
      true  -> changeset
    end
  end

  defp authenticate(changeset), do: changeset

  defp sign_in({:ok, session}) do
    {:ok, jwt, %{"exp" => exp}} = Guardian.encode_and_sign(session, :access)

    {:ok, session.user, jwt, exp}
  end

  defp sign_in({:error, changeset}), do: {:error, changeset}
end
