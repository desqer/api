defmodule Desqer.Type.PhoneTest do
  use ExUnit.Case, async: true

  @phone %{
    international_code: "55",
    area_code: "47",
    number: "999554321",
    full_number: "5547999554321"
  }

  test "#cast" do
    {:ok, phone} = Desqer.Type.Phone.cast("+55 (47) 99955-4321")

    assert phone.international_code == @phone.international_code
    assert phone.area_code == @phone.area_code
    assert phone.number == @phone.number
    assert phone.full_number == @phone.full_number
  end

  test "#cast when phone is map" do
    assert Desqer.Type.Phone.cast(@phone) == {:ok, @phone}
  end

  test "#cast when phone is not valid" do
    assert Desqer.Type.Phone.cast("123") == :error
    assert Desqer.Type.Phone.cast(nil) == :error
  end

  test "#load" do
    {:ok, phone} = Desqer.Type.Phone.load("+55 (47) 99955-4321")

    assert phone.international_code == @phone.international_code
    assert phone.area_code == @phone.area_code
    assert phone.number == @phone.number
    assert phone.full_number == @phone.full_number
  end

  test "#dump" do
    {:ok, phone} = Desqer.Type.Phone.dump("+55 (47) 99955-4321")

    assert phone == @phone.full_number
  end

  test "#dump when phone is map" do
    {:ok, phone} = Desqer.Type.Phone.dump(@phone)

    assert phone == @phone.full_number
  end

  test "#dump when phone is not valid" do
    assert Desqer.Type.Phone.dump("123") == :error
    assert Desqer.Type.Phone.dump(nil) == :error
  end
end
