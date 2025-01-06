defmodule Boreray.List.Filter do
  @moduledoc false
  alias Boreray.Coercion
  alias Boreray.Coercion.Undefined

  def update(list, %{filter: operations}) do
    operations
    |> Enum.reduce(list, &apply_operation/2)
    |> Enum.into([])
  end

  defp apply_operation(%{
    regex: regex,
    value: val,
    op: op,
    type: type,
    field: field
  }, stream) do
    Stream.filter(stream, fn %{^field => field_value} ->
      evaluate(Coercion.cast(field_value, type), op, regex || val)
    end)
  end

  defp evaluate(_, _, %Undefined{}), do: false
  defp evaluate(%Undefined{}, _, _), do: false

  defp evaluate(field_value, op, %Decimal{} = val) do
    __MODULE__.NumericValue.evaluate(field_value, op, val)
  end

  defp evaluate(field_value, op, nil) do
    __MODULE__.NullValue.evaluate(field_value, op)
  end

  defp evaluate(field_value, op, val) when is_list(val) do
    evaluate(field_value, op, MapSet.new(val))
  end

  defp evaluate(field_value, op, %MapSet{} = val) do
    __MODULE__.SetValue.evaluate(field_value, op, val)
  end

  defp evaluate(field_value, op, %Regex{} = val) do
    __MODULE__.RegexValue.evaluate(field_value, op, val)
  end

  defp evaluate(field_value, op, val) do
    __MODULE__.Common.evaluate(field_value, op, val)
  end
end
