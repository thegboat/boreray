defmodule Boreray.List.Filter.NumericValue do
  @moduledoc """
  Module for updating a query with generic comparison rules for most fields
  """

  def evaluate(field_value, op, val) do
    field_value
    |> Decimal.compare(val)
    |> do_evaluate(op)
  end

  defp do_evaluate(cmp, :not), do: cmp != :eq
  defp do_evaluate(cmp, :lte), do: cmp != :gt
  defp do_evaluate(cmp, :gte), do: cmp != :lt
  defp do_evaluate(cmp, op), do: cmp == op
end
