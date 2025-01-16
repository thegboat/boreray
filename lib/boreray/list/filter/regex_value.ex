defmodule Boreray.List.Filter.RegexValue do
  @moduledoc """
  Module for updating a query with string field comparison rules
  """

  @l ~w(like ilike)a
  @nl ~w(not_like not_ilike)a

  def evaluate(field_value, op, val) when op in @l do
    field_value =~ val
  end

  def evaluate(field_value, op, val) when op in @nl do
    not (field_value =~ val)
  end
end
