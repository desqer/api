defmodule Desqer.ChangesetViewTest do
  use Desqer.ConnCase, async: true

  import Phoenix.View

  test "renders error.json" do
    rendered = render(Desqer.ChangesetView, "error.json", changeset: user_changeset)

    assert rendered == %{errors: %{phone: ["can't be blank"]}}
  end

  defp user_changeset do
    %Desqer.User{}
    |> Ecto.Changeset.change
    |> Ecto.Changeset.validate_required([:phone])
  end
end
