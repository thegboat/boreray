defmodule Boreray.EctoQuery.SortTest do
  use ExUnit.Case
  require Ecto.Query
  alias Boreray.EctoQuery.Sort

  defmodule FakeResource do
    use Ecto.Schema

    schema "example_table" do
      field(:string_field, :string)
    end
  end

  setup do
    query = FakeResource.__schema__(:query)
    {:ok, query: query}
  end

  describe "update/2" do
    test "adds sort parameters accordingly", %{query: initial} do
      query = Sort.update(initial, %{sort: :string_field, sort_dir: :desc})
      q = inspect(query)
      assert q =~ ~r/order_by: \[desc: \w{2}.string_field\]/

      query = Sort.update(initial, %{sort: :string_field, sort_dir: :asc})
      q = inspect(query)
      assert q =~ ~r/order_by: \[asc: \w{2}.string_field\]/
    end
  end
end
