defmodule Boreray do
  @moduledoc false
  require Ecto.Query

  def build(module, params) when is_atom(module) do
    query = Ecto.Query.from(x in Ecto.Query.subquery(module))
    build(module, query, params)
  end

  def build(module, query, params) do
    schema = __MODULE__.Schema.build(module)
    plan = __MODULE__.Planner.build_plan(params, schema)
    __MODULE__.EctoQuery.build(query, plan)
  end
end
