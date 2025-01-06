defmodule Boreray.List.Sort do
  @moduledoc false
  alias Boreray.Coercion.Undefined

  def update(list, %{sort: nil}), do: Enum.into(list, [])

  def update(list, %{sort: field, sort_dir: dir, sort_type: type}) do
    {sortable, other} = list
    |> Stream.map(fn struct -> 
      {get_sort_value(struct, field, type), struct}
    end)
    |> Enum.split_with(fn 
      {%Undefined{}, _} -> false
      _ -> true
    end)

    sortable
    |> sort(dir)
    |> Stream.map(&elem(&1, 1))
    |> Stream.concat(other)
  end

  defp sort(list, :asc) do
    Enum.sort_by(list, &elem(&1, 0))
  end

  defp sort(list, :desc) do
    list
    |> sort(:asc)
    |> Enum.reverse()
  end

  defp get_sort_value(struct, field, type) do
    struct
    |> Map.fetch!(field)
    |> Boreray.Coercion.cast(type)
  end
end
