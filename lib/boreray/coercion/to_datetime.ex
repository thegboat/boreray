defmodule Boreray.Coercion.ToDatetime do

  def cast(val) when is_binary(val) do
    with {:error, _} <- DateTimeParser.parse(val, assume_time: true) do
      :error
    end
  end

  def cast(%DateTime{} = val), do: val

  def cast(%Date{} = val) do
    DateTime.new(val, Time.new!(0, 0, 0), "Etc/UTC")
  end

  def cast(%NaiveDateTime{} = val) do
    DateTime.from_naive(val, "Etc/UTC")
  end

  def cast(_), do: :error

  def format_datetime!(val, shift_opts \\ []) do
    case cast(val) do
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