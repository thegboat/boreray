defmodule POSAdapter.Prism.QueryFilters.GenericField do
  @moduledoc """
  Module for updating a query with generic comparison rules for most fields
  """

  import Ecto.Query, only: [where: 3]

  @spec evaluate(Ecto.Query.t(), atom(), String.t(), any()) :: Ecto.Query.t()
  def evaluate(query, field, "eq", val) do
    where(query, [x], field(x, ^field) == ^val)
  end

  def evaluate(query, field, "not", val) do
    where(query, [x], is_nil(field(x, ^field)) or field(x, ^field) != ^val)
  end

  def evaluate(query, field, "gt", val) do
    where(query, [x], field(x, ^field) > ^val)
  end

  def evaluate(query, field, "lt", val) do
    where(query, [x], field(x, ^field) < ^val)
  end

  def evaluate(query, field, "gte", val) do
    where(query, [x], field(x, ^field) >= ^val)
  end

  def evaluate(query, field, "lte", val) do
    where(query, [x], field(x, ^field) <= ^val)
  end

  def evaluate(_query, _field, op, _val) when op in ~w(in not_in) do
    raise "The operator (`#{op}`) should be used with a list value"
  end

  def evaluate(_query, _field, op, _val) when op in ~w(like not_like) do
    raise "The operator (`#{op}`) should be used with a string field"
  end

  def evaluate(_query, _field, op, _val) do
    raise "The operator (`#{op}`) is invalid"
  end
end
