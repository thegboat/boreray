defmodule Boreray.Coercion.ToDatetime do
  @moduledoc false
  alias Boreray.Coercion.Undefined

  def cast(val) do
    case parse(val) do
      {:error, _} -> %Undefined{type: :datetime, value: val}
      {:ok, parsed} ->
        parsed
        |> DateTime.shift_zone!("Etc/UTC")
        |> format()
    end
  end

  defp parse(val) when is_binary(val) do
    DateTimeParser.parse(val, assume_time: true)
  end

  defp parse(%DateTime{} = val), do: {:ok, val}

  defp parse(%Date{} = val) do
    DateTime.new(val, ~T[00:00:00], "Etc/UTC")
  end

  defp parse(%Time{} = val) do
    DateTime.new(~D[0000-01-01], val, "Etc/UTC")
  end

  defp parse(%NaiveDateTime{} = val) do
    DateTime.from_naive(val, "Etc/UTC")
  end

  defp format(t) do
    micro = format_microseconds(t.microsecond)
    "#{pad(t.year)}-#{pad(t.month)}-#{pad(t.day)} #{pad(t.hour)}:#{pad(t.minute)}:#{pad(t.second)}.#{micro}"
  end

  defp pad(int) do
    int
    |> to_string()
    |> String.pad_leading(2, "0")
  end

  defp format_microseconds({0, _}), do: "0"
  defp format_microseconds({int, pad}) do
    int
    |> to_string()
    |> String.trim_trailing("0")
    |> String.pad_leading(pad, "0")
  end
end
