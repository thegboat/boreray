defmodule Boreray.List.Filter.SetValue do
  @moduledoc """
  Module for updating a query with list value comparison rules
  """

  def evaluate(field_value, op, %MapSet{} = val) do
    do_evaluate(field_value, op, val)
  end
  
  defp do_evaluate(field_value, :eq, val) do
    do_evaluate(field_value, :in, val)
  end
  
  defp do_evaluate(field_value, :not_eq, val) do
    do_evaluate(field_value, :not_in, val)
  end

  defp do_evaluate(field_value, :in, val) do
    field_value in val
  end

  defp do_evaluate(field_value, :not_in, val) do
    field_value not in val
  end

  defp do_evaluate(_field_value, op, _val) do
    invalid_op_error(op)
  end

  defp invalid_op_error(op) do
    raise "Invalid operator (`#{op}`) for comparison with a list value."
  end
end
