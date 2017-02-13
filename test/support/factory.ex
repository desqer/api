defmodule Desqer.Factory do
  use ExMachina.Ecto, repo: Desqer.Repo

  def user_factory do
    %Desqer.User{
      password_hash: "$2b$12$FCtaN0gpgxBUgxsPGNBVD.Khs3KvH7oiW76eLF/o8QRT4Cei5RSoS",
      name: "John Doe",
      email: "john@doe.com",
      bio: "An awesome professional",
      professional: true,
      confirmed: true,
      deleted: false,
      phone: %{
        a2: "BR",
        a3: "BRA",
        area_abbreviation: "SC",
        area_code: "47",
        area_name: "Santa Catarina",
        area_type: "state",
        country: "Brazil",
        full_number: "5547999874321",
        international_code: "55",
        number: "999874321"}
    }
  end

  def session_factory do
    %Desqer.Session{
      user: build(:user),
      user_agent: "Mozilla/5.0 (Macintosh)",
      remote_ip: {172, 68, 29, 248},
      revoked: false
    }
  end
end
