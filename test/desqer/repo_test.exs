defmodule Desqer.RepoTest do
  use Desqer.ModelCase, async: true

  test "#exists? when has no results" do
    refute Desqer.Repo.exists?(from u in Desqer.User)
  end

  test "#exists? when has results" do
    insert(:user)

    assert Desqer.Repo.exists?(from u in Desqer.User)
  end
end
