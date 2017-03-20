defmodule Desqer.Action.CreateProfessional do
  import Ecto.Changeset

  def run(user, user_params, venue_params) do
    Ecto.Multi.new
    |> Ecto.Multi.update(:user, user_changeset(user, user_params))
    |> Ecto.Multi.insert(:venue, venue_changeset(venue_params))
    |> Ecto.Multi.run(:professional, &insert_professional/1)
    |> Desqer.Repo.transaction
  end

  defp user_changeset(user, params) do
    user
    |> cast(params, [:email, :bio])
    |> update_change(:email, &downcase/1)
    |> validate_not_profissional(user)
    |> put_change(:professional, true)
  end

  defp venue_changeset(params) do
    params = params |> normalize_phones |> normalize_links

    %Desqer.Venue{}
    |> cast(params, [:name, :lat, :lon, :address])
    |> cast_assoc(:phones, with: &phones_changeset/2)
    |> cast_assoc(:links, with: &links_changeset/2)
  end

  defp phones_changeset(phone, params) do
    cast(phone, params, [:type, :value])
  end

  defp links_changeset(link, params) do
    cast(link, params, [:type, :name, :url])
  end

  defp insert_professional(%{user: user, venue: venue}) do
    %Desqer.Professional{}
    |> change
    |> put_change(:owner, true)
    |> put_assoc(:user, user)
    |> put_assoc(:venue, venue)
    |> Desqer.Repo.insert
  end

  defp validate_not_profissional(changeset, user) do
    if user.professional,
      do: add_error(changeset, :professional, "has already been taken"),
      else: changeset
  end

  defp normalize_phones(%{"phone" => value} = params) when not is_nil(value) do
    phone = %{"type" => "main", "value" => value}
    Map.put(params, "phones", [phone])
  end

  defp normalize_phones(params), do: params

  defp normalize_links(%{"website" => url} = params) when not is_nil(url) do
    link = %{"type" => Desqer.Collection.LinkType.website, "url" => url}
    Map.put(params, "links", [link])
  end

  defp normalize_links(params), do: params

  defp downcase(value) when is_binary(value), do: String.downcase(value)
  defp downcase(_), do: nil
end
