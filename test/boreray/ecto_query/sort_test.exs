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
    {:ok, query: Ecto.Query.from(x in Ecto.Query.subquery(query))}
  end

  describe "update/2" do
    test "adds sort parameters accordingly", %{query: initial} do
      assert {query, %{}} = Sort.update({initial, %{"sort" => "string_field", "sort_dir" => "desc"}}, FakeResource)
      q = inspect(query)
      assert q =~ ~r/order_by: \[desc: \w{2}.string_field\]/

      assert {query, %{}} = Sort.update({initial, %{"sort" => "string_field"}}, FakeResource)
      q = inspect(query)
      assert q =~ ~r/order_by: \[asc: \w{2}.string_field\]/
    end
  end
end
