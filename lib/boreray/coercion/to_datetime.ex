defmodule Boreray.Coercion.ToDatetime do
  @moduledoc false
  alias Boreray.Coercion.Undefined

  def cast(val) do
    case parse(val) do
      {:error, _} -> %Undefined{type: :datetime, value: val}
      {:ok, parsed} -> format(parsed)
    end
  end

  def parse(val) when is_binary(val) do
    DateTimeParser.parse(val, assume_time: true)
  end

  def parse(%DateTime{} = val), do: {:ok, val}

  def parse(%Date{} = val) do
    DateTime.new(val, Time.new!(0, 0, 0), "Etc/UTC")
  end

  def parse(%NaiveDateTime{} = val) do
    DateTime.from_naive(val, "Etc/UTC")
  end

  defp format(t) do
    "#{pad(t.year)}-#{pad(t.month)}-#{pad(t.day)} #{pad(t.hour)}:#{pad(t.minute)}:#{pad(t.second)}"
  end

  defp pad(int) do
    int
    |> to_string()
    |> String.pad_leading(2, "0")
  end
end
