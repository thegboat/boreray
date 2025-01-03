defmodule Boreray.EctoQuery.Filter.StringField do
  @moduledoc """
  Module for updating a query with string field comparison rules
  """

  import Ecto.Query, only: [where: 3]
  alias Boreray.EctoQuery.Filter.Common

  @spec evaluate(Ecto.Query.t(), atom(), String.t(), any()) :: Ecto.Query.t()
  def evaluate(query, field, op, val) do
    do_evaluate(query, field, op, to_string(val))
  end

  def do_evaluate(query, field, :like, val) do
    where(query, [x], fragment("REGEXP_LIKE(?, ?, 'in')", field(x, ^field), ^val))
  end

  def do_evaluate(query, field, :not_like, val) do
    where(
      query,
      [x],
      is_nil(field(x, ^field)) or fragment("NOT REGEXP_LIKE(?, ?, 'in')", field(x, ^field), ^val)
    )
  end

  def do_evaluate(query, field, op, val) do
    Common.evaluate(query, field, op, val)
  end
end
