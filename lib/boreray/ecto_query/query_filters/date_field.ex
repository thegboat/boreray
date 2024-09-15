defmodule POSAdapter.Prism.QueryFilters.DateField do
  @moduledoc """
  Module for updating a query with datetime field comparison rules
  """

  import Ecto.Query, only: [where: 3]
  import POSAdapter.Utils, only: [format_datetime: 1]
  alias POSAdapter.Prism.QueryFilters.GenericField

  @format "YYYY-MM-DD HH24:MI:SS"

  @spec evaluate(Ecto.Query.t(), atom(), String.t(), any()) :: Ecto.Query.t()
  def evaluate(query, field, op, val) do
    casted = cast(val)
    do_evaluate(query, field, op, casted)
  end

  defp do_evaluate(query, field, "eq", val) do
    where(query, [x], field(x, ^field) == fragment("TO_DATE(?, ?)", ^val, @format))
  end

  defp do_evaluate(query, field, "gt", val) do
    where(query, [x], field(x, ^field) > fragment("TO_DATE(?, ?)", ^val, @format))
  end

  defp do_evaluate(query, field, "lt", val) do
    where(query, [x], field(x, ^field) < fragment("TO_DATE(?, ?)", ^val, @format))
  end

  defp do_evaluate(query, field, "gte", val) do
    where(query, [x], field(x, ^field) >= fragment("TO_DATE(?, ?)", ^val, @format))
  end

  defp do_evaluate(query, field, "lte", val) do
    where(query, [x], field(x, ^field) <= fragment("TO_DATE(?, ?)", ^val, @format))
  end

  defp do_evaluate(query, field, "not", val) do
    where(query, [x], field(x, ^field) != fragment("TO_DATE(?, ?)", ^val, @format))
  end

  defp do_evaluate(query, field, op, val) do
    GenericField.evaluate(query, field, op, val)
  end

  defp cast(val) do
    case format_datetime(val) do
      {:ok, parsed} -> parsed
      _ -> raise "The filter value could not be parsed into not a date or datetime."
    end
  end
end
