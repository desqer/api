defmodule Desqer.Type.IP do
  @behaviour Ecto.Type

  def type, do: :string

  def cast(ip) when is_tuple(ip), do: {:ok, ip}
  def cast(ip) when is_binary(ip), do: to_tuple(ip)
  def cast(_), do: :error

  def load(ip), do: cast(ip)

  def dump(ip) when is_binary(ip), do: {:ok, ip}
  def dump(ip) when is_tuple(ip), do: to_binary(ip)
  def dump(_), do: :error

  defp to_tuple(address) do
    address
    |> String.to_char_list
    |> :inet.parse_address
    |> case do
      {:ok, ip} -> {:ok, ip}
      {:error, :einval} -> :error
    end
  end

  defp to_binary(address) do
    ip = address
    |> :inet.ntoa
    |> List.to_string

    {:ok, ip}
  end
end
