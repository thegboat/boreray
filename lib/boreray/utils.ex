defmodule Boreray.Utils do
  @moduledoc false
  alias Boreray.Coercion.ToDatetime

  def format_datetime!(val, shift_opts \\ []) do
    case ToDatetime.cast(val) do
      {:ok, parsed} ->
        shifted = Timex.shift(parsed, shift_opts)
        do_format_datetime(shifted)
      :error ->
        raise "The filter value could not be parsed into not a date or datetime."
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