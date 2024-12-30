defmodule Boreray.EctoQuery.Sort do
  @moduledoc false
  import Ecto.Query, only: [order_by: 3]

  def update(query, %{sort: nil}), do: query

  def update(query, %{sort: field, sort_dir: dir}) do
    order_by(query, [q], [{^dir, field(q, ^field)}])
  end
end
