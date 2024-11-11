defmodule Boreray.EctoQuery.PaginationTest do
  use ExUnit.Case
  require Ecto.Query
  alias Boreray.EctoQuery.Pagination

  defmodule FakeResource do
    use Ecto.Schema

    schema "example_table" do
      field(:boolean_field, :boolean)
    end
  end

  setup do
    query = FakeResource.__schema__(:query)
    {:ok, query: Ecto.Query.from(x in Ecto.Query.subquery(query))}
  end

  describe "update/1" do
    test "adds pagination accordingly", %{query: initial} do
      assert {query, %{}} = Pagination.update({initial, %{"page" => "all", "per_page" => "25"}})
      q = inspect(query)
      refute q =~ ~r/limit:/
      refute q =~ ~r/offset:/

      assert {query, %{}} = Pagination.update({initial, %{"per_page" => "25"}})
      q = inspect(query)
      assert q =~ ~r/limit: \^25, offset: \^0/

      assert {query, %{}} = Pagination.update({initial, %{"page" => 3, "per_page" => 25}})
      q = inspect(query)

      assert q =~ ~r/limit: \^25, offset: \^50/

      assert {query, %{}} = Pagination.update({initial, %{"page" => 3.2, "per_page" => "25"}})
      q = inspect(query)

      assert q =~ ~r/limit: \^25, offset: \^50/
    end
  end
end
