defmodule Boreray.Utils do
  @moduledoc false
  alias Boreray.Coercion.ToDatetime

  defmacro is_datetime(type) do
    quote do:
            unquote(type) in [
              :date,
              :utc_datetime,
              :naive_datetime,
              :utc_datetime_usec,
              :naive_datetime_usec
            ]
  end

  defmacro is_date(type) do
    quote do:
            unquote(type) in [
              :date
            ]
  end

  def field_info(module, field) when is_atom(field) do
    field_info(module, field, to_string(field))
  end

  def field_info(module, field) when is_binary(field) do
    as_atom = String.to_existing_atom(field)
    field_info(module, as_atom, field)
  rescue
    ArgumentError -> :error
    e -> raise e
  end

  def invalid_field(module, field) do
    name = module
    |> Module.split()
    |> Stream.reject(& &1 == "Elixir")
    |> Enum.join(".")

    "The field `#{field}` is not valid for resource #{name}"
  end

  def format_datetime!(val, shift_opts \\ []) do
    case ToDatetime.cast(val) do
      {:ok, parsed} ->
        shifted = Timex.shift(parsed, shift_opts)
        do_format_datetime(shifted)
      :error ->
        raise "The filter value could not be parsed into not a date or datetime."
    end
  end

  defp field_info(module, field_as_atom, field_as_string) do
    case module.__schema__(:type, field_as_atom) do
      nil ->
        :error

      type ->
        source = module.__schema__(:field_source, field_as_atom) || field_as_atom
        {field_as_string, type, to_string(source)}
    end
  end

  defp do_format_datetime(t) do
    "#{pad(t.year)}-#{pad(t.month)}-#{pad(t.day)} #{pad(t.hour)}:#{pad(t.minute)}:#{pad(t.second)}"
  end

  defp pad(int) do
    int
    |> to_string()
    |> String.pad_leading(2, "0")
  end
end