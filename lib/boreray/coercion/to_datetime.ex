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

end