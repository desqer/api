defmodule Desqer.Action.DeleteSessionTest do
  use Desqer.ModelCase, async: true

  test "revokes session access" do
    session = insert(:session)
    {:ok, session} = Desqer.Action.DeleteSession.run(session)

    assert session.revoked
  end
end
