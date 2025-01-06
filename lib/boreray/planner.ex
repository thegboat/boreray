defmodule Boreray.Planner do
  @moduledoc false

  alias Boreray.Coercion
  alias Boreray.Operation
  alias Boreray.Plan

  @ops ~w(eq not is is_not in not_in like ilike not_like not_ilike gt lt gte lte)

  def build_plan(params, schema) when is_list(params) do
    build_plan(%{"filter" => Map.new(params)}, schema)
  end

  def build_plan(params, schema) when is_map(params) do
    params
    |> Stream.flat_map(fn {k, v} -> add_param(to_string(k), v, schema) end)
    |> Stream.reject(fn {_k, v, _e} -> is_nil(v) end)
    |> Enum.reduce(%Plan{}, fn {key, value, errors}, plan ->
      plan
      |> Map.put(key, value)
      |> Map.put(:errors, Enum.concat(errors, plan.errors))
    end)
  end

  defp add_param("per_page", limit, _schema) do
    {:limit, to_int(limit), []}
  end

  defp add_param("limit", limit, _schema) do
    {:limit, to_int(limit), []}
  end

  defp add_param("page", page, _schema) do
    {:page, to_int(page), []}
  end

  defp add_param("sort", field, schema) do
    type = schema[field]
    error = type && invalid_field_error(field)

    [
      {:sort, field, List.wrap(error)},
      {:sort_type, field, []}
    ]
  end

  defp add_param("sort_dir", dir, _schema) do
    dir
    |> to_string()
    |> String.downcase()

    case dir do
      "desc" -> {:sort_dir, :desc, []}
      _ -> {:sort_dir, :asc, []}
    end
  end

  defp add_param("filter", v, schema) do
    {operations, errors} = flatten_to_operations(v, schema)
    {:filter, operations, errors}
  end

  defp add_param(_, _, _), do: {:unsupported, nil, []}

  def flatten_to_operations(params, schema) do
    params
    |> Stream.flat_map(fn {field, ops} ->
      build_operations(field, schema[field], ops)
    end)
    |> Enum.split_with(&is_binary/1)
  end

  defp build_operations(field, nil, _ops) do
    invalid_field_error(field)
  end

  defp build_operations(field, type, ops) when is_map(ops) do
    Enum.map(ops, fn {op, val} ->
      build_operation(field, type, to_string(op), val)
    end)
  end

  defp build_operations(field, type, val) do
    build_operation(field, type, "eq", val)
  end

  defp build_operation(field, type, op, val) when op in @ops do
    op = String.to_atom(op)
    val = Coercion.cast(val, type, op)

    %Operation{
      field: field,
      type: type,
      op: normalize_op(op),
      value: val,
      regex: Coercion.cast(val, :regex, op)
    }
  end

  defp build_operation(field, _type, op, _val) do
    invalid_op_error(field, op)
  end

  defp normalize_op(:is), do: :eq
  defp normalize_op(:is_not), do: :not
  defp normalize_op(op), do: op

  defp invalid_op_error(field, op) do
    "The operator `#{op}` for field `#{field}` is invalid."
  end

  defp invalid_field_error(field) do
    "The field `#{field}` is not a valid field for the schema."
  end

  defp to_int(i) when is_binary(i) do
    i
    |> Integer.parse()
    |> case do
      :error -> nil
      {int, _} -> to_int(int)
    end
  end

  defp to_int(i) when is_number(i) do
    i = floor(i)
    if(i > 0, do: i, else: nil)
  end

  defp to_int(_), do: nil
end
