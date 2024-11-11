defmodule Boreray.EctoQuery.Filter.NullValue do
  @moduledoc """
  Module for updating a query with null value comparison rules
  """

  import Ecto.Query, only: [where: 3]

  @spec evaluate(Ecto.Query.t(), atom(), String.t()) :: Ecto.Query.t()
  def evaluate(query, field, "eq") do
    where(query, [x], is_nil(field(x, ^field)))
  end

  def evaluate(query, field, "not") do
    where(query, [x], not is_nil(field(x, ^field)))
  end

  def evaluate(query, _field, _op) do
    where(query, [x], false)
  end
end
