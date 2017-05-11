defmodule Desqer.Type.String do
  @behaviour Ecto.Type

  def type, do: :string

  def cast(value) when is_binary(value), do: {:ok, trim(value)}
  def cast(_), do: :error

  def load(value), do: cast(value)

  def dump(value) when is_binary(value), do: {:ok, trim(value)}
  def dump(_), do: :error

  defp trim(value) do
    String.trim(value)
  end
end
