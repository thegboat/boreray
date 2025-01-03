defmodule Boreray.EctoQuery do
  @moduledoc false
  require Ecto.Query
  alias Boreray.Planner
  alias Boreray.Schema

  def build(module, params) when is_atom(module) do
    query = Ecto.Query.from(x in Ecto.Query.subquery(module))
    build(module, query, params)
  end

  def build(module, %Ecto.Query{} = query, params) do
    schema = Schema.build(module)
    plan = Planner.build_plan(params, schema)
    do_build(query, plan)
  end

  defp do_build(queryable, plan) do
    queryable
    |> __MODULE__.Pagination.update(plan)
    |> __MODULE__.Sort.update(plan)
    |> __MODULE__.Filter.update(plan)
  end
end