defmodule Desqer.Type.Hours do
  @behaviour Ecto.Type

  def type, do: {:array, :string}

  def cast([range | _] = hours) when is_binary(range) do
    {:ok, Enum.map(hours, &to_time_range/1)}
  end

  def cast([range | _] = hours) when is_tuple(range) do
    {:ok, hours}
  end

  def cast([] = hours), do: {:ok, hours}
  def cast(_), do: :error

  def load(value), do: cast(value)

  def dump([range | _] = hours) when is_tuple(range) do
    {:ok, Enum.map(hours, &from_time_range/1)}
  end

  def dump([range | _] = hours) when is_binary(range) do
    {:ok, hours}
  end

  def dump([] = hours), do: {:ok, hours}
  def dump(_), do: :error

  defp to_time_range(<<from::bytes-size(5)>> <> "-" <> <<to::bytes-size(5)>>) do
    {to_time(from), to_time(to)}
  end

  defp to_time(naive_value) do
    Time.from_iso8601!("#{naive_value}:00")
  end

  defp from_time_range({from, to}) do
    from_time(from) <> "-" <> from_time(to)
  end

  defp from_time(value) do
    value
    |> Time.to_string
    |> String.slice(0, 5)
  end
end
