defmodule Desqer.Factory do
  use ExMachina.Ecto, repo: Desqer.Repo

  def user_factory do
    %Desqer.User{
      phone: "5547999874321",
      password_hash: "$2b$12$FCtaN0gpgxBUgxsPGNBVD.Khs3KvH7oiW76eLF/o8QRT4Cei5RSoS",
      name: "John Doe",
      email: "john@doe.com",
      bio: "An awesome professional",
      professional: true,
      confirmed: true,
      deleted: false
    }
  end
end
