defmodule Boreray.EctoQuery.SortTest do
  use ExUnit.Case
  require Ecto.Query
  alias Boreray.EctoQuery.Sort
  alias Boreray.Schema

  defmodule FakeResource do
    use Ecto.Schema

    schema "example_table" do
      field(:string_field, :string)
    end
  end

  setup do
    query = FakeResource.__schema__(:query)
    schema = Schema.build(FakeResource)
    {:ok, query: query, schema: schema}
  end

  describe "update/2" do
    test "adds sort parameters accordingly", %{query: initial, schema: schema} do
      query = Sort.update(initial, %{"sort" => "string_field", "sort_dir" => "desc"}, schema)
      q = inspect(query)
      assert q =~ ~r/order_by: \[desc: \w{2}.string_field\]/

      query = Sort.update(initial, %{"sort" => "string_field", "sort_dir" => "asc"}, schema)
      q = inspect(query)
      assert q =~ ~r/order_by: \[asc: \w{2}.string_field\]/
    end
  end
end
