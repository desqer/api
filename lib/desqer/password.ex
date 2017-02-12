defmodule Desqer.Password do
  def hash(nil), do: nil
  def hash(""), do: nil

  def hash(password) when is_binary(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end

  def check(nil, _), do: fake_check()
  def check("", _), do: fake_check()
  def check(_, nil), do: fake_check()
  def check(_, ""), do: fake_check()

  def check(password, password_hash) when is_binary(password) and is_binary(password_hash) do
    Comeonin.Bcrypt.checkpw(password, password_hash)
  end

  defp fake_check do
    Comeonin.Bcrypt.dummy_checkpw
  end
end
