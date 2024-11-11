defmodule Boreray.EctoQuery.Filter.CommonTest do
  use ExUnit.Case
  require Ecto.Query
  alias Boreray.EctoQuery.Filter.Common

  setup do
    {:ok, query: Ecto.Query.from(x in "example_table")}
  end

  describe "evaluate/4" do
    test "updates query properly when operator is `eq`", %{query: query} do
      query = Common.evaluate(query, :foo, "eq", 1)
      q = inspect(query)

      assert q =~ ~r/\w{2}\.foo == \^1/
    end

    test "updates query properly when operator is `not`", %{query: query} do
      query = Common.evaluate(query, :foo, "not", 1)
      q = inspect(query)

      assert q =~ ~r/\w{2}\.foo != \^1/
    end

    test "updates query properly when operator is `lt`", %{query: query} do
      query = Common.evaluate(query, :foo, "lt", 1)
      q = inspect(query)

      assert q =~ ~r/\w{2}\.foo < \^1/
    end

    test "updates query properly when operator is `lte`", %{query: query} do
      query = Common.evaluate(query, :foo, "lte", 1)
      q = inspect(query)

      assert q =~ ~r/\w{2}\.foo <= \^1/
    end

    test "updates query properly when operator is `gt`", %{query: query} do
      query = Common.evaluate(query, :foo, "gt", 1)
      q = inspect(query)

      assert q =~ ~r/\w{2}\.foo > \^1/
    end

    test "updates query properly when operator is `gte`", %{query: query} do
      query = Common.evaluate(query, :foo, "gte", 1)
      q = inspect(query)

      assert q =~ ~r/\w{2}\.foo >= \^1/
    end

    test "raise error when operator is `in`", %{query: query} do
      assert_raise RuntimeError, fn ->
        Common.evaluate(query, :foo, "in", "2020-01-01T01:01:01")
      end
    end

    test "raise error when operator is `not_in`", %{query: query} do
      assert_raise RuntimeError, fn ->
        Common.evaluate(query, :foo, "not_in", "2020-01-01T01:01:01")
      end
    end

    test "raise error when operator is `like`", %{query: query} do
      assert_raise RuntimeError, fn ->
        Common.evaluate(query, :foo, "like", "astring")
      end
    end

    test "raise error when operator is `not_like`", %{query: query} do
      assert_raise RuntimeError, fn ->
        Common.evaluate(query, :foo, "not_like", "astring")
      end
    end
  end
end
