defmodule Boreray.Schema do
  @moduledoc false

  def build(module, valid_types) when is_atom(module) do
    cond do
      sorta_ecto?(module) ->
        ecto_build(module, valid_types)

      function_exported?(module, :__field_info__, 0) ->
        module_build(module, valid_types)

      true ->
        raise_module_error(module)
    end
  end

  def build(schema, valid_types) when is_list(schema) or is_map(schema) do
    schema
    |> Stream.map(fn {f, t} ->
      type = valid_types[to_string(t)]

      if is_nil(type) do
        raise_unknown_type(t)
      else
        {to_atom(f), type}
      end
    end)
    |> Map.new()
  end

  defp ecto_build(module, valid_types) do
    :fields
    |> module.__schema__()
    |> Enum.map(&{&1, module.__schema__(:type, &1)})
    |> build(valid_types)
  end

  defp module_build(module, valid_types) do
    build(module.__field_info__(), valid_types)
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
