defmodule Boreray.EctoQuery do
  @moduledoc false

  def build(queryable, plan) do
    queryable
    |> __MODULE__.Pagination.update(plan)
    |> __MODULE__.Sort.update(plan)
    |> __MODULE__.Filter.update(plan)
  end
end