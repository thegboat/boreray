defmodule Boreray.Coercion.ToNumeric do
  @moduledoc false
  alias Boreray.Coercion.Undefined

  def cast(%Decimal{} = val), do: val

  def cast(val) when is_number(val) do
    val
    |> to_string()
    |> cast()
  end

  def cast(val) when is_binary(val) do
    val
    |> String.trim()
    |> Decimal.cast()
    |> case do
      {:ok, casted} -> casted
      _ -> %Undefined{type: :number, value: val}
    end
  end
end