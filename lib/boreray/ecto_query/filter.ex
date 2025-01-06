defmodule Boreray.EctoQuery.Filter do
  @moduledoc false

  def update(src_query, %{filter: operations}) do
    Enum.reduce(operations, src_query, fn %{
                                            op: op,
                                            type: type,
                                            field: field,
                                            value: value
                                          },
                                          query ->
      evaluate(query, field, type, op, value)
    end)
  end

  defp evaluate(query, field, _type, op, nil) do
    __MODULE__.NullValue.evaluate(query, field, op)
  end

  defp evaluate(query, field, _type, op, val) when is_list(val) do
    __MODULE__.ListValue.evaluate(query, field, op, val)
  end

  defp evaluate(query, field, type, op, %MapSet{} = val) do
    evaluate(query, field, type, op, MapSet.to_list(val))
  end

  defp evaluate(query, field, :boolean, op, val) do
    __MODULE__.BooleanField.evaluate(query, field, op, val)
  end

  defp evaluate(query, field, :date, op, val) do
    __MODULE__.DateField.evaluate(query, field, op, val)
  end

  defp evaluate(query, field, :datetime, op, val) do
    __MODULE__.TimestampField.evaluate(query, field, op, val)
  end

  defp evaluate(query, field, :string, op, val) do
    __MODULE__.StringField.evaluate(query, field, op, val)
  end

  defp evaluate(query, field, _, op, val) do
    __MODULE__.Common.evaluate(query, field, op, val)
  end
end
