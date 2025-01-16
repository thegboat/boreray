defmodule Boreray.Coercion do
  @moduledoc false

  @numeric ~w(integer decimal float)a
  @nulls ~w(NULL null nil)
  @is ~w(is is_not)a
  @re ~w(like not_like ilike not_ilike)a

  def cast(list, type) when is_list(list) do
    Enum.map(list, &cast(&1, type))
  end

  def cast(val, type) when type in @numeric do
    __MODULE__.ToNumeric.cast(val)
  end

  def cast(val, :boolean) do
    __MODULE__.ToBoolean.cast(val)
  end

  def cast(val, :string) do
    to_string(val)
  end

  def cast(val, :datetime) do
    __MODULE__.ToDatetime.cast(val)
  end

  def cast(val, _type), do: val

  def cast(val, _type, op) when op in @is and val in @nulls, do: nil

  def cast(val, :regex, op) when op in @re do
    opt = if(op in ~w(ilike not_ilike)a, do: "i", else: "")
    val
    |> to_string()
    |> __MODULE__.ToRegex.cast(opt)
  end

  def cast(_val, :regex, _op), do: nil

  def cast(val, type, _op), do: cast(val, type)
end