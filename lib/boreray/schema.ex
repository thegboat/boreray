defmodule Boreray.Schema do
  @moduledoc false

  import Boreray.Utils, only: [to_atom: 1]

  @types %{
    "integer" => :integer,
    "float" => :decimal,
    "boolean" => :boolean,
    "string" => :string,
    "binary" => :string,
    "decimal" => :decimal,
    "id" => :integer,
    "binary_id" => :string,
    "utc_datetime" => :datetime,
    "naive_datetime" => :datetime,
    "map" => :any,
    "any" => :any,
    "date" => :datetime,
    "time" => :time,
    "time_usec" => :time,
    "utc_datetime_usec" => :datetime,
    "naive_datetime_usec" => :datetime
  }

  def build(module) when is_atom(module) do
    cond do
      sorta_ecto?(module)  ->
        ecto_build(module)
      function_exported?(module, :__field_info__, 0) ->
        module_build(module)
      true ->
        raise_module_error(module)
    end
  end

  def build(schema) when is_list(schema) or is_map(schema) do
    schema
    |> Stream.map(fn {f, t} ->
      type = @types[to_string(t)]

      if is_nil(type) do
        raise_unknown_type(type)
      else
        {to_atom(f), type}
      end
    end)
    |> Map.new()   
  end

  defp ecto_build(module) do
    :fields
    |> module.__schema__()
    |> Enum.map(& {&1, module.__schema__(:type, &1)})
    |> build()
  end

  defp module_build(module) do
    build(module.__field_info__)
  end

  defp sorta_ecto?(module) do
    function_exported?(module, :__schema__, 1) && function_exported?(module, :__schema__, 2)
  end

  def to_atom(field) when is_binary(field) do
    String.to_existing_atom(field)
  rescue
    _ ->
      raise "The field name `#{field}` does not appear to be a field of previously defined struct."
  end

  def to_atom(field) when is_atom(field), do: field

  defp raise_unknown_type(type) do
    raise "The type, #{type} is not supported."
  end

  defp raise_module_error(module) do
    raise "The module, #{module}, does not export a function to retrieve field info."
  end
end