defmodule Desqer.Collection do
  defmacro __using__(collection) do
    quote location: :keep, bind_quoted: [collection: collection] do
      import Desqer.Gettext, only: [dgettext: 2]

      @behaviour Ecto.Type

      def type, do: :string

      for key <- collection, atom = key, string = Atom.to_string(key) do
        def cast(unquote(string)), do: {:ok, unquote(atom)}
        def cast(unquote(atom)), do: {:ok, unquote(atom)}
        def load(unquote(string)), do: {:ok, unquote(atom)}
        def dump(unquote(string)), do: {:ok, unquote(string)}
        def dump(unquote(atom)), do: {:ok, unquote(string)}

        def unquote(key)(), do: unquote(atom)
        def unquote(:"#{key}?")(unquote(atom)), do: true
        def unquote(:"#{key}?")(unquote(string)), do: true
        def unquote(:"#{key}?")(_), do: false

        def translate(unquote(string)), do: dgettext("enumerations", unquote(string))
        def translate(unquote(atom)), do: dgettext("enumerations", unquote(string))
      end

      def cast(_), do: :error
      def load(_), do: :error
      def dump(_), do: :error

      def all, do: unquote(collection)
      def to_options, do: for key <- unquote(collection), do: {translate(key), key}
    end
  end
end
