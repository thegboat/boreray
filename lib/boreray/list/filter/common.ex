defmodule Boreray.List.Filter.Common do
  @moduledoc """
  Module for updating a query with generic comparison rules for most fields
  """

  def evaluate(fv, :eq, val), do: fv == val
  def evaluate(fv, :not, val), do: fv != val
  def evaluate(fv, :gt, val), do: fv > val
  def evaluate(fv, :lt, val), do: fv < val
  def evaluate(fv, :gte, val), do: fv >= val
  def evaluate(fv, :lte, val), do: fv <= val

  def evaluate(_fv, op, _val) when op in ~w(in not_in)a do
    raise "The operator (`#{op}`) should be used with a list value"
  end

  def evaluate(_fv, _op, _val), do: false
end
