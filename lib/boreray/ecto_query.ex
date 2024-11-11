defmodule Boreray.EctoQuery do
  @moduledoc false

  def build(queryable, params, module) do
    {queryable, params}
    |> __MODULE__.Pagination.update()
    |> __MODULE__.Sort.update(module)
    |> __MODULE__.Filter.update(module)
  end
end