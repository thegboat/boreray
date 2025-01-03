defmodule Boreray.EctoQuery.Filter.BooleanField do
  @moduledoc false

  import Ecto.Query, only: [where: 3]
  alias Boreray.Coercion.ToBoolean

  @spec evaluate(Ecto.Query.t(), atom(), String.t(), any()) :: Ecto.Query.t()
  def evaluate(query, field, op, val) do
    case {cast(val), op} do
      {:error, val} -> raise "The value `#{val}` could not be cast to `boolean` type."
      {casted, :eq} -> where(query, [x], field(x, ^field) == ^casted)
      {casted, :not} -> where(query, [x], field(x, ^field) != ^casted)
      _ -> raise "`boolean` type fields can only be used with `eq` or `not` operator"
    end
  end

  defp cast(val) do
    with {:ok, casted} <- ToBoolean.cast(val) do
      casted
    end
  end
end
