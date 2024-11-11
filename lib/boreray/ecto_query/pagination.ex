defmodule Boreray.EctoQuery.Pagination do
  @moduledoc false
  import Ecto.Query, only: [offset: 2, limit: 2]

  def update({query, params}) do
    do_update(query, params)
  end

  defp do_update(query, %{"page" => "all"} = params) do
    {query, Map.drop(params, ["page", "per_page", "limit"])}
  end

  defp do_update(query, %{"per_page" => _} = params) do
    {per_page, params} = Map.pop(params, "per_page")
    {page, params} = Map.pop(params, "page")
    params = Map.delete(params, "limit")

    query = case to_int(per_page) do
      nil -> 
        query
      valid_per_page ->
        page = to_int(page) || 1
        offset = (page - 1) * valid_per_page
        query
        |> offset(^offset)
        |> limit(^valid_per_page)
    end

    {query, params}
  end

  defp do_update(query, %{"limit" => limit} = params) do
    params = Map.put(params, "per_page", limit)
    do_update(query, params)
  end

  defp do_update(query, params) do
    params = Map.drop(params, ["page"])
    {query, params}
  end

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
