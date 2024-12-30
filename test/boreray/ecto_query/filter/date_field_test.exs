defmodule Boreray.EctoQuery.Filter.DateFieldTest do
  use ExUnit.Case
  require Ecto.Query
  alias Boreray.EctoQuery.Filter.DateField

  setup do
    {:ok, query: Ecto.Query.from(x in "example_table")}
  end

  describe "evaluate/4" do
    test "updates query properly when operator is `eq` and type is date", %{query: query} do
      query = DateField.evaluate(query, :foo, :eq, "2020-01-01T01:01:01")
      q = inspect(query)

      assert q =~
               ~r/\w{2}\.foo == fragment\("TO_DATE\(\?, 'YYYY-MM-DD HH24:MI:SS'\)", \^"2020-01-01 01:01:01"\)/
    end

    test "updates query properly when operator is `not` and type is date", %{query: query} do
      query = DateField.evaluate(query, :foo, :not, "2020-01-01T01:01:01")
      q = inspect(query)

      assert q =~
               ~r/\w{2}\.foo != fragment\("TO_DATE\(\?, 'YYYY-MM-DD HH24:MI:SS'\)", \^"2020-01-01 01:01:01"\)/
    end

    test "updates query properly when operator is `lt` and type is date", %{query: query} do
      query = DateField.evaluate(query, :foo, :lt, "2020-01-01T01:01:01")
      q = inspect(query)

      assert q =~
               ~r/\w{2}\.foo < fragment\("TO_DATE\(\?, 'YYYY-MM-DD HH24:MI:SS'\)", \^"2020-01-01 01:01:01"\)/
    end

    test "updates query properly when operator is `lte` and type is date", %{query: query} do
      query = DateField.evaluate(query, :foo, :lte, "2020-01-01T01:01:01")
      q = inspect(query)

      assert q =~
               ~r/\w{2}\.foo <= fragment\("TO_DATE\(\?, 'YYYY-MM-DD HH24:MI:SS'\)", \^"2020-01-01 01:01:01"\)/
    end

    test "updates query properly when operator is `gt` and type is date", %{query: query} do
      query = DateField.evaluate(query, :foo, :gt, "2020-01-01T01:01:01")
      q = inspect(query)

      assert q =~
               ~r/\w{2}\.foo > fragment\("TO_DATE\(\?, 'YYYY-MM-DD HH24:MI:SS'\)", \^"2020-01-01 01:01:01"\)/
    end

    test "updates query properly when operator is `gte` and type is date", %{query: query} do
      query = DateField.evaluate(query, :foo, :gte, "2020-01-01T01:01:01")
      q = inspect(query)

      assert q =~
               ~r/\w{2}\.foo >= fragment\("TO_DATE\(\?, 'YYYY-MM-DD HH24:MI:SS'\)", \^"2020-01-01 01:01:01"\)/
    end
  end
end
