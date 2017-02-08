defmodule Desqer.Type.Phone do
  @behaviour Ecto.Type

  def type, do: :string

  def cast(phone) when is_map(phone) do
    {:ok, with_full_number(phone)}
  end

  def cast(phone) do
    case Phone.parse(phone) do
      {:ok, phone} -> {:ok, with_full_number(phone)}
      {:error, _} -> :error
    end
  end

  def load(phone), do: cast(phone)

  def dump(phone) when is_map(phone) do
    {:ok, full_number(phone)}
  end

  def dump(phone) do
    case Phone.parse(phone) do
      {:ok, phone} -> dump(phone)
      {:error, _} -> :error
    end
  end

  defp full_number(phone) do
    [phone.international_code, phone.area_code, phone.number]
    |> Enum.join
  end

  defp with_full_number(phone) do
    Map.put phone, :full_number, full_number(phone)
  end
end
