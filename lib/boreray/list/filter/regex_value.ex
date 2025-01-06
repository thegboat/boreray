defmodule Boreray.List.Filter.RegexValue do
  @moduledoc """
  Module for updating a query with string field comparison rules
  """

  def evaluate(field_value, :like, val) do
    field_value =~ val
  end

  def evaluate(field_value, :not_like, val) do
    not (field_value =~ val)
  end
end
