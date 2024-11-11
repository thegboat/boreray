defmodule Boreray.EctoQuery.Sort do
  @moduledoc false
  import Ecto.Query, only: [order_by: 3]
  import Boreray.Utils, only: [field_info: 2, invalid_field: 2]

  def update({query, params}, module) do
    do_update(query, params, module)
  end

  defp do_update(query, %{"sort" => _} = params, module) do
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

  defp do_update(query, params, _), do: {query, params}
end
