defmodule POSAdapter.Utils do
  @moduledoc false

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

  def field_info(module, field) when is_binary(field) do
    as_atom = String.to_existing_atom(field)
    case module.__schema__(:type, as_atom) do
      nil ->
        :error

      type ->
        source = module.__schema__(:field_source, as_atom) || field
        {field, type, to_string(source)}
    end
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

  def field_info(module, field) when is_atom(field) do
    field_info(module, to_string(field))
  end

  def format_datetime(val, opts \\ []) do
    with {:ok, parsed} <- DateTimeParser.parse(val, assume_time: true) do
      shifted = Timex.shift(parsed, opts)
      {:ok, do_format_datetime(shifted)}
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