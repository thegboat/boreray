defmodule Boreray.EctoQuery.Filter.DateField do
  @moduledoc """
  Module for updating a query with datetime field comparison rules
  """

  import Ecto.Query, only: [where: 3]
  alias Boreray.EctoQuery.Filter.Common

  defmacrop to_date(val) do
    quote do
      fragment("TO_DATE(?, 'YYYY-MM-DD HH24:MI:SS')", ^unquote(val))
    end
  end

  @spec evaluate(Ecto.Query.t(), atom(), String.t(), String.t()) :: Ecto.Query.t()
  def evaluate(query, field, :eq, val) do
    where(query, [x], field(x, ^field) == to_date(val))
  end

  def evaluate(query, field, :gt, val) do
    where(query, [x], field(x, ^field) > to_date(val))
  end

  def evaluate(query, field, :lt, val) do
    where(query, [x], field(x, ^field) < to_date(val))
  end

  def evaluate(query, field, :gte, val) do
    where(query, [x], field(x, ^field) >= to_date(val))
  end

  def evaluate(query, field, :lte, val) do
    where(query, [x], field(x, ^field) <= to_date(val))
  end

  def evaluate(query, field, :not, val) do
    where(query, [x], field(x, ^field) != to_date(val))
  end

  def evaluate(query, field, op, val) do
    Common.evaluate(query, field, op, val)
  end
end
