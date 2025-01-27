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
      query = Pagination.update(initial, %{limit: 25})
      q = inspect(query)
      assert q =~ ~r/limit: \^25/

      query = Pagination.update(initial, %{page: 3, limit: 25})
      q = inspect(query)

      assert q =~ ~r/limit: \^25, offset: \^50/
    end
  end
end
