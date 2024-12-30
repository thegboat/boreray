defmodule Boreray.EctoQuery.Filter.ListValue do
  @moduledoc """
  Module for updating a query with list value comparison rules
  """

  import Ecto.Query, only: [where: 3]

  @spec evaluate(Ecto.Query.t(), atom(), String.t(), list(any())) :: Ecto.Query.t()
  def evaluate(query, field, op, val) when is_list(val) do
    do_evaluate(query, field, op, val)
  end

  defp do_evaluate(query, _field, :in, []) do
    where(query, [x], false)
  end

  defp do_evaluate(query, field, :in, val) do
    where(query, [x], field(x, ^field) in ^val)
  end

  defp do_evaluate(query, _field, :not_in, []) do
    query
  end

  defp do_evaluate(query, field, :not_in, val) do
    where(query, [x], is_nil(field(x, ^field)) or field(x, ^field) not in ^val)
  end

  defp do_evaluate(query, field, :eq, val) do
    do_evaluate(query, field, :in, val)
  end

  defp do_evaluate(query, field, :not, val) do
    do_evaluate(query, field, :not_in, val)
  end

  defp do_evaluate(_query, _field, op, _val) do
    raise "Invalid operator (`#{op}`) for comparison with a list value."
  end
end
