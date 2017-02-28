defmodule Desqer.Repo do
  use Ecto.Repo, otp_app: :desqer

  import Ecto.Query

  def exists?(query) do
    !!one(from q in query, select: 1, limit: 1)
  end
end
