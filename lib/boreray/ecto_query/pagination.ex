defmodule Boreray.EctoQuery.Pagination do
  @moduledoc false
  import Ecto.Query, only: [offset: 2, limit: 2]

  def update(query, %{page: page, limit: limit}) do
    offset = (page - 1) * limit
    query
    |> offset(^offset)
    |> limit(^limit)
  end

  def update(query, %{limit: limit}) do
    limit(query, ^limit)
  end

  def update(query, _), do: query
end
