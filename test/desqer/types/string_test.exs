defmodule Desqer.Type.StringTest do
  use ExUnit.Case, async: true

  test "#cast trims content" do
    assert Desqer.Type.String.cast("  Foo  ") == {:ok, "Foo"}
  end

  test "#cast when type is not valid" do
    assert Desqer.Type.String.cast(1) == :error
  end

  test "#load" do
    assert Desqer.Type.String.load("  Foo  ") == {:ok, "Foo"}
  end

  test "#dump trims content" do
    assert Desqer.Type.String.load("  Foo  ") == {:ok, "Foo"}
  end

  test "#dump when type is not valid" do
    assert Desqer.Type.String.dump(1) == :error
  end
end
