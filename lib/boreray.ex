defmodule Boreray do
  @moduledoc false
  require Ecto.Query

  def build(module, params) when is_atom(module) do
    build(module, params, module)
  end

  def build(queryable, params, module) do
    query = Ecto.Query.from(x in Ecto.Query.subquery(queryable))
    Boreray.EctoQuery.build(query, prepare(params), module)
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
end
