defmodule Boreray.List.Filter.NullValue do
  @moduledoc """
  Module for updating a query with null value comparison rules
  """

  def evaluate(field_value, :eq) do
    is_nil(field_value)
  end

  def evaluate(field_value, :not) do
    !is_nil(field_value)
  end

  def evaluate(_field_value, _op), do: false
end
