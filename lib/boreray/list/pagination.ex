defmodule Boreray.List.Pagination do
  @moduledoc false

  def update(list, %{limit: nil}), do: list

  def update(list, %{page: page, limit: limit}) do
    offset = get_offset(page, limit)

    list
    |> chunk_every(limit)
    |> Enum.at(offset)
  end

  defp get_offset(_page, nil), do: 0
  defp get_offset(nil, _limit), do: 0

  defp get_offset(page, limit) do
    (page - 1) * limit
  end

  defp chunk_every(list, nil), do: [list]

  defp chunk_every(list, limit) do
    Stream.chunk_every(list, limit)
  end
end
