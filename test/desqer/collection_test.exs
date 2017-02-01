defmodule Desqer.CollectionTest do
  use ExUnit.Case, async: true

  defmodule Dumb do
    use Desqer.Collection, [:foo]
  end

  test "#all" do
    assert Dumb.all == [:foo]
  end

  test "#to_options" do
    assert Dumb.to_options == [{"foo", :foo}]
  end

  test "#foo" do
    assert Dumb.foo == :foo
    assert_raise UndefinedFunctionError, fn -> Dump.bar end
  end

  test "#foo?" do
    assert Dumb.foo?("foo")
    assert Dumb.foo?(:foo)
    refute Dumb.foo?("bar")
    refute Dumb.foo?(:bar)
    assert_raise UndefinedFunctionError, fn -> Dump.bar?("bar") end
    assert_raise UndefinedFunctionError, fn -> Dump.bar?(:bar) end
  end

  test "#translate" do
    foo = Dumb.translate("foo")
    ^foo = Dumb.translate(:foo)

    assert foo == "foo"
    assert_raise UndefinedFunctionError, fn -> Dump.translate("bar") end
    assert_raise UndefinedFunctionError, fn -> Dump.translate(:bar) end
  end

  test "#cast" do
    {:ok, foo} = Dumb.cast("foo")
    {:ok, ^foo} = Dumb.cast(:foo)

    assert foo == :foo
    assert :error == Dumb.cast("bar")
    assert :error == Dumb.cast(:bar)
  end

  test "#load" do
    {:ok, foo} = Dumb.load("foo")

    assert foo == :foo
    assert :error == Dumb.load("bar")
  end

  test "#dump" do
    {:ok, foo} = Dumb.dump(:foo)
    {:ok, ^foo} = Dumb.dump("foo")

    assert foo == "foo"
    assert :error == Dumb.dump(:bar)
    assert :error == Dumb.dump("bar")
  end
end
