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

  def venue_factory do
    %Desqer.Venue{
      name: "John's Studio",
      lat: -27.216093,
      lon: -49.643502,
      address: "Sete de setembro, 123 - Rio do Sul - SC"
    }
  end

  def role_factory do
    %Desqer.Role{
      user: build(:user),
      venue: build(:venue),
      name: "Hair Stylist",
      owner: true
    }
  end

  def service_factory do
    %Desqer.Service{
      role: build(:role),
      name: "Hair Cut",
      description: "Scissors and fire, wash included.",
      price: 4900,
      duration: 40,
      in_advance: 2,
      status: Desqer.Collection.ServiceStatus.active,
      need_approval: false,
      online_scheduling: true,
      sunday: [],
      monday: [{~T[13:00:00], ~T[20:00:00]}],
      tuesday: [{~T[13:00:00], ~T[20:00:00]}],
      wednesday: [{~T[13:00:00], ~T[20:00:00]}],
      thursday: [{~T[13:00:00], ~T[20:00:00]}],
      friday: [{~T[13:00:00], ~T[20:00:00]}],
      saturday: []
    }
  end

  def appointment_factory do
    %Desqer.Appointment{
      user: build(:user, phone: "5547999864321"),
      service: build(:service),
      name: "Hair Cute Cut",
      description: "Fancy style for your hair",
      price: 3900,
      starts_at: %Ecto.DateTime{year: 2017, month: 3, day: 12, hour: 13, min: 0, sec: 0},
      ends_at: %Ecto.DateTime{year: 2017, month: 3, day: 12, hour: 13, min: 30, sec: 0},
      notes: "Some client specific issues",
      status: Desqer.Collection.AppointmentStatus.active
    }
  end
end
