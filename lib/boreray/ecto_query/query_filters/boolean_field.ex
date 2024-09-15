defmodule POSAdapter.Prism.QueryFilters.BooleanField do
  @moduledoc """
  Module for updating a query with boolean field comparison rules
  castable values:
  :true
  :false
  "T" or "t"
  "F" or "f"
  0 or "0"
  1 or "1"
  case insensitive "True" (i.e. TrUe)
  case insensitive "False" (i.e. FaLsE)
  """

  import Ecto.Query, only: [where: 3]

  @spec evaluate(Ecto.Query.t(), atom(), String.t(), any()) :: Ecto.Query.t()
  def evaluate(query, field, op, val) do
    case {cast(val), op} do
      {nil, _} -> raise "`boolean` type fields can only be compared with `true` or `false`"
      {casted, "eq"} -> where(query, [x], field(x, ^field) == ^casted)
      {casted, "not"} -> where(query, [x], field(x, ^field) != ^casted)
      _ -> raise "`boolean` type fields can only be used with `eq` or `not` operator"
    end
  end

  defp cast(val) do
    casted =
      val
      |> to_string()
      |> String.trim()

    cond do
      casted =~ ~r/^(true|1|t)$/i -> true
      casted =~ ~r/^(false|0|f)$/i -> false
      true -> nil
    end
  end
end
