defmodule Boreray.EctoQuery.Filter.TimestampFieldTest do
  use ExUnit.Case
  require Ecto.Query
  alias Boreray.EctoQuery.Filter.TimestampField

  setup do
    {:ok, query: Ecto.Query.from(x in "example_table")}
  end

  describe "evaluate/4" do
    test "updates query properly when operator is `eq` and type is timestamp", %{query: query} do
      query = TimestampField.evaluate(query, :foo, :eq, "2020-01-01 01:01:01")
      q = inspect(query)

      assert q =~
               ~r/\w{2}\.foo == fragment\("TO_TIMESTAMP\(\?, 'YYYY-MM-DD HH24:MI:SS'\)", \^"2020-01-01 01:01:01"\)/
    end

    test "updates query properly when operator is `not` and type is timestamp", %{query: query} do
      query = TimestampField.evaluate(query, :foo, :not, "2020-01-01 01:01:01")
      q = inspect(query)

      assert q =~
               ~r/\w{2}\.foo != fragment\("TO_TIMESTAMP\(\?, 'YYYY-MM-DD HH24:MI:SS'\)", \^"2020-01-01 01:01:01"\)/
    end

    test "updates query properly when operator is `lt` and type is timestamp", %{query: query} do
      query = TimestampField.evaluate(query, :foo, :lt, "2020-01-01 01:01:01")
      q = inspect(query)

      assert q =~
               ~r/\w{2}\.foo < fragment\("TO_TIMESTAMP\(\?, 'YYYY-MM-DD HH24:MI:SS'\)", \^"2020-01-01 01:01:01"\)/
    end

    test "updates query properly when operator is `lte` and type is timestamp", %{query: query} do
      query = TimestampField.evaluate(query, :foo, :lte, "2020-01-01 01:01:01")
      q = inspect(query)

      assert q =~
               ~r/\w{2}\.foo <= fragment\("TO_TIMESTAMP\(\?, 'YYYY-MM-DD HH24:MI:SS'\)", \^"2020-01-01 01:01:01"\)/
    end

    test "updates query properly when operator is `gt` and type is timestamp", %{query: query} do
      query = TimestampField.evaluate(query, :foo, :gt, "2020-01-01 01:01:01")
      q = inspect(query)

      assert q =~
               ~r/\w{2}\.foo > fragment\("TO_TIMESTAMP\(\?, 'YYYY-MM-DD HH24:MI:SS'\)", \^"2020-01-01 01:01:01"\)/
    end

    test "updates query properly when operator is `gte` and type is timestamp", %{query: query} do
      query = TimestampField.evaluate(query, :foo, :gte, "2020-01-01 01:01:01")
      q = inspect(query)

      assert q =~
               ~r/\w{2}\.foo >= fragment\("TO_TIMESTAMP\(\?, 'YYYY-MM-DD HH24:MI:SS'\)", \^"2020-01-01 01:01:01"\)/
    end
  end
end
