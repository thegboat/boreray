defmodule Boreray.Coercion do
  @moduledoc false

  @numeric ~w(integer decimal integer)
  @nulls ~w(NULL null nil)
  @is ~w(is is_not)a
  @caseful ~w(like not_like)a
  @caseless ~w(ilike not_ilike)a

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

  def cast(val, :regex, op) when is_binary(val) and op in @caseful do
    __MODULE__.ToRegex.cast(val)
  end  
  
  def cast(val, :regex, op) when is_binary(val) and op in @caseless do
    __MODULE__.ToRegex.cast(val, "i")
  end

  def cast(_val, :regex, _op), do: nil

  def cast(val, type, _op), do: cast(val, type)
end