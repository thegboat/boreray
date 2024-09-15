defmodule Boreray.EctoQuery.Filters do
  @moduledoc false
  import Boreray.Utils, only: [is_datetime: 1, is_date: 1]

  def update_query(module, query, params) do
    with {:ok, tuples} <- flatten(params) do
      {:ok, Enum.reduce(tuples, query, &evaluate_per_field/2)}
    end
  end

  defp evaluate_per_field({field, _source, type, filters}, src_query) do
    field = String.to_atom(field)

    filters
    |> Stream.map(fn {op, val} -> {to_string(op), val} end)
    |> Enum.reduce(src_query, fn
      {operator, value}, query ->
        evaluate(query, field, type, to_string(operator), value)

      _, query ->
        query
    end)
  end

  defp evaluate(query, field, _type, op, nil) do
    __MODULE__.NullValue.evaluate(query, field, op)
  end

  defp evaluate(query, field, _type, op, val) when is_list(val) do
    __MODULE__.ListValue.evaluate(query, field, op, val)
  end

  defp evaluate(query, field, :boolean, op, val) do
    __MODULE__.BooleanField.evaluate(query, field, op, val)
  end

  defp evaluate(query, field, type, op, val) when is_date(type) do
    __MODULE__.DateField.evaluate(query, field, op, val)
  end

  defp evaluate(query, field, type, op, val) when is_datetime(type) do
    __MODULE__.TimestampField.evaluate(query, field, op, val)
  end

  defp evaluate(query, field, :string, op, val) do
    __MODULE__.StringField.evaluate(query, field, op, val)
  end

  defp evaluate(query, field, _, op, val) do
    __MODULE__.GenericField.evaluate(query, field, op, val)
  end

  defp flatten(params) do
    params
    |> get_field_info(module)
    |> Enum.split_with(&is_binary/1)
    |> case do
      {[], tuples} ->
        {:ok, Enum.uniq_by(tuples, &elem(&1, 0))}

      {[field | _], _} ->
        name =
          module
          |> Module.split()
          |> Enum.slice(-2..-1)
          |> Enum.join(".")

        {:error, "The field `#{field}` is not valid for resource #{name}"}
    end
  end

  defp inject_subsidiary_id(params, module) do
    Enum.reduce(module.subsidiary_id_fields(), params, fn field, acc ->
      Map.put(acc, field, %{"eq" => Base.subsidiary_id()})
    end)
  end

  defp get_field_info(params, module) do
    Enum.map(params, fn {field, filters} ->
      field
      |> to_string()
      |> field_info()
      |> case do
        {field, type, source} ->
          {field, source, type, filters}

        :error ->
          to_string(field)
      end
    end)
  end
end
