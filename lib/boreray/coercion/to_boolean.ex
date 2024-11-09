defmodule Boreray.Coercion.ToBoolean do
  @moduledoc false

  def cast(val) do
    casted =
      val
      |> to_string()
      |> String.trim()

    cond do
      casted =~ ~r/^(true|1|t)$/i -> true
      casted =~ ~r/^(false|0|f)$/i -> false
      true -> :error
    end
  end
end