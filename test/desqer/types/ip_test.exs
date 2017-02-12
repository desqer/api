defmodule Desqer.Type.IPTest do
  use ExUnit.Case, async: true

  test "#cast" do
    assert Desqer.Type.IP.cast({192,168,1,113}) == {:ok, {192,168,1,113}}
    assert Desqer.Type.IP.cast("192.168.1.113") == {:ok, {192,168,1,113}}
  end

  test "#cast when type is not valid" do
    assert Desqer.Type.IP.cast(1) == :error
  end

  test "#load" do
    assert Desqer.Type.IP.load("192.168.1.113") == {:ok, {192,168,1,113}}
  end

  test "#dump" do
    assert Desqer.Type.IP.dump("192.168.1.113") == {:ok, "192.168.1.113"}
    assert Desqer.Type.IP.dump({192,168,1,113}) == {:ok, "192.168.1.113"}
  end

  test "#dump when type is not valid" do
    assert Desqer.Type.IP.dump(1) == :error
  end
end
