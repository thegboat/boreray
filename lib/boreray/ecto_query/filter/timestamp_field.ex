defmodule Boreray.EctoQuery.Filter.TimestampField do
  @moduledoc """
  Module for updating a query with datetime field comparison rules
  """

  import Ecto.Query, only: [where: 3]
  import Boreray.Utils, only: [format_datetime!: 1]
  alias Boreray.EctoQuery.Filter.Common

  defmacrop to_timestamp(val) do
    quote do
      fragment("TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS')", ^unquote(val))
    end
  end

  @spec evaluate(Ecto.Query.t(), atom(), String.t(), any()) :: Ecto.Query.t()
  def evaluate(query, field, op, val) do
    formatted = format_datetime!(val)
    do_evaluate(query, field, op, formatted)
  end

  defp do_evaluate(query, field, "eq", val) do
    where(query, [x], field(x, ^field) == to_timestamp(val))
  end

  defp do_evaluate(query, field, "gt", val) do
    where(query, [x], field(x, ^field) > to_timestamp(val))
  end

  defp do_evaluate(query, field, "lt", val) do
    where(query, [x], field(x, ^field) < to_timestamp(val))
  end

  defp do_evaluate(query, field, "gte", val) do
    where(query, [x], field(x, ^field) >= to_timestamp(val))
  end

  defp do_evaluate(query, field, "lte", val) do
    where(query, [x], field(x, ^field) <= to_timestamp(val))
  end

  defp do_evaluate(query, field, "not", val) do
    where(query, [x], field(x, ^field) != to_timestamp(val))
  end

  defp do_evaluate(query, field, op, val) do
    Common.evaluate(query, field, op, val)
  end
end