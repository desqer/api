defmodule Desqer.GuardianSerializerTest do
  use Desqer.ModelCase, async: true

  test "#for_token" do
    session = insert(:session)

    assert Desqer.GuardianSerializer.for_token(%{}) == {:error, "Unknown resource type"}
    assert Desqer.GuardianSerializer.for_token(nil) == {:error, "Unknown resource type"}
    assert Desqer.GuardianSerializer.for_token(session) == {:ok, "Session:#{session.id}"}
  end

  test "#from_token" do
    session = insert(:session)

    assert Desqer.GuardianSerializer.from_token("") == {:error, "Unknown resource type"}
    assert Desqer.GuardianSerializer.from_token(nil) == {:error, "Unknown resource type"}
    assert Desqer.GuardianSerializer.from_token("Session:#{session.id}") == {:ok, session}
  end
end

