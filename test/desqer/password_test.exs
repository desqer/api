defmodule Desqer.PasswordTest do
  use ExUnit.Case, async: true

  @password_hash "$2b$12$FCtaN0gpgxBUgxsPGNBVD.Khs3KvH7oiW76eLF/o8QRT4Cei5RSoS"

  test "#hash" do
    password_hash = Desqer.Password.hash("1234")

    assert Desqer.Password.check("1234", password_hash)
    assert Desqer.Password.hash(nil) == nil
    assert Desqer.Password.hash("") == nil
  end

  test "#check" do
    refute Desqer.Password.check(nil, @password_hash)
    refute Desqer.Password.check("", @password_hash)
    refute Desqer.Password.check("1234", nil)
    refute Desqer.Password.check("1234", "")
    refute Desqer.Password.check("foobar", @password_hash)
    assert Desqer.Password.check("1234", @password_hash)
  end

  test "#check with map" do
    refute Desqer.Password.check("1234", %{password_hash: nil})
    refute Desqer.Password.check("1234", %{password_hash: ""})
    refute Desqer.Password.check(nil, %{password_hash: @password_hash})
    refute Desqer.Password.check("", %{password_hash: @password_hash})
    refute Desqer.Password.check("foobar", %{password_hash: @password_hash})
    assert Desqer.Password.check("1234", %{password_hash: @password_hash})
  end

  test "#fake_check" do
    refute Desqer.Password.fake_check
  end
end
