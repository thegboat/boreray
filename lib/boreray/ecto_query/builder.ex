defmodule Boreray.EctoQuery.Builder do
  @moduledoc false
  import Ecto.Query
  import Boreray.Utils, only: [field_info: 2, invalid_field: 2]

  alias Boreray.EctoQuery.Filters

  def build(module, params) do
    {module, prepare(params)}
    |> add_pagination()
    |> add_sort(module)
    |> add_filter(module)
  end

  def build(module, queryable, params) do
    {queryable, prepare(params)}
    |> add_pagination()
    |> add_sort(module)
    |> add_filter(module)
  end

  defp add_pagination({query, %{"page" => "all"} = params}) do
    add_pagination({query, Map.drop(params, ["page", "per_page", "limit"])})
  end

  defp add_pagination({query, %{"per_page" => _} = params}) do
    {per_page, params} = Map.pop(params, "per_page")
    {page, params} = Map.pop(params, "page")
    params = Map.delete(params, "limit")
    per_page = to_int(per_page) || 50
    page = to_int(page) || 1

    offset = (page - 1) * per_page

    query =
      query
      |> offset(^offset)
      |> limit(^per_page)

    {query, params}
  end

  defp add_pagination({query, %{"limit" => limit} = params}) do
    add_pagination({query, Map.put(params, "per_page", limit)})
  end

  defp add_pagination({query, params}) do
    {query, Map.drop(params, ["per_page", "page"])}
  end

  defp add_sort({query, %{"sort" => _} = params}, module) do
    {field, params} = Map.pop(params, "sort")
    {dir, params} = Map.pop(params, "sort_dir")

    field_data = field_info(module, field)

    case {dir, field_data} do
      {"desc", {field, _type, _source}} ->
        {order_by(query, [q], desc: field(q, ^String.to_atom(field))), params}

      {_, {field, _type, _source}} ->
        {order_by(query, [q], asc: field(q, ^String.to_atom(field))), params}

      _ ->
        raise invalid_field(module, field)
    end
  end

  defp add_sort(args, _), do: args

  defp add_filter({query, params}, module) do
    {filter, params} = Map.pop(params, "filter")

    with {:ok, updated_query} <- Filters.update_query(module, query, filter) do
      {:ok, updated_query, params}
    end
  end

  defp prepare(params) do
    params
    |> normalize_params()
    |> normalize_filter()
  end

  defp normalize_params(params) when is_list(params) do
    %{"filter" => Map.new(params)}
  end

  defp normalize_params(params) when is_map(params) do
    params
    |> Stream.map(fn {k, v} -> {to_string(k), v} end)
    |> Map.new()
  end

  defp normalize_filter(%{"filter" => filter} = params) do
    filter =
      filter
      |> Stream.map(fn {k, v} ->
        v = if(is_map(v), do: v, else: %{"eq" => v})
        {to_string(k), v}
      end)
      |> Enum.into(%{})

    Map.put(params, "filter", filter)
  end

  defp normalize_filter(params), do: params

  defp to_int(i) when is_integer(i), do: i
  defp to_int(nil), do: nil
  defp to_int(i) when is_number(i), do: floor(i)

  defp to_int(i) when is_binary(i) do
    i
    |> Integer.parse()
    |> case do
      :error -> nil
      {int, _} -> int
    end
  end

  defp to_int(_), do: nil
end
