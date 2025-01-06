defmodule Boreray.Coercion.ToRegex do
  @moduledoc false
  alias Boreray.Coercion.Undefined

  def cast(val) do
    cast(val, nil)
  end

  def cast(val, opts) when is_binary(val) do
    val
    |> String.trim()
    |> Regex.compile("#{opts}m")
    |> case do
      {:ok, compiled} -> compiled
      _ -> %Undefined{type: :regex, value: val}
    end
  end
end