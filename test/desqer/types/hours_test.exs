defmodule Desqer.Type.HoursTest do
  use ExUnit.Case, async: true

  @hours [
    {~T[08:00:00], ~T[12:00:00]},
    {~T[13:00:00], ~T[18:00:00]}
  ]

  test "#cast when ranges are strings" do
    {:ok, hours} = Desqer.Type.Hours.cast(["08:00-12:00", "13:00-18:00"])

    assert hours == @hours
  end

  test "#cast when ranges are tuples" do
    assert Desqer.Type.Hours.cast(@hours) == {:ok, @hours}
  end

  test "#cast when hours is empty" do
    assert Desqer.Type.Hours.cast([]) == {:ok, []}
  end

  test "#cast when hours is not valid" do
    assert Desqer.Type.Hours.cast("123") == :error
    assert Desqer.Type.Hours.cast(nil) == :error
  end

  test "#load" do
    {:ok, hours} = Desqer.Type.Hours.load(["08:00-12:00", "13:00-18:00"])

    assert hours == @hours
  end

  test "#dump when ranges are tuples" do
    {:ok, hours} = Desqer.Type.Hours.dump(@hours)

    assert hours == ["08:00-12:00", "13:00-18:00"]
  end

  test "#dump when ranges are strings" do
    {:ok, hours} = Desqer.Type.Hours.dump(["08:00-12:00", "13:00-18:00"])

    assert hours == ["08:00-12:00", "13:00-18:00"]
  end

  test "#dump when hours is empty" do
    assert Desqer.Type.Hours.dump([]) == {:ok, []}
  end

  test "#dump when hours is not valid" do
    assert Desqer.Type.Hours.dump("123") == :error
    assert Desqer.Type.Hours.dump(nil) == :error
  end
end
