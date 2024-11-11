defmodule Boreray.EctoQuery.Filter.ListValueTest do
  use ExUnit.Case
  require Ecto.Query
  alias Boreray.EctoQuery.Filter.ListValue

  setup do
    {:ok, query: Ecto.Query.from(x in "example_table")}
  end

  describe "evaluate/4" do
    test "updates query properly with `in` operator and non empty list", %{query: query} do
      query = ListValue.evaluate(query, :foo, "in", [1, 2])
      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/\w{2}\.foo in \^\[1, 2\]/
    end

    test "updates query properly with `in` operator and empty list", %{query: query} do
      query = ListValue.evaluate(query, :foo, "in", [])
      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/false/
    end

    test "updates query properly with `not_in` operator and non empty list", %{query: query} do
      query = ListValue.evaluate(query, :foo, "not_in", [1, 2])
      q = inspect(query)

      assert q =~ ~r/is_nil\(\w{2}\.foo\) or \w{2}\.foo not in \^\[1, 2\]/
    end

    test "noop with `not_in` operator and empty list", %{query: query} do
      query = ListValue.evaluate(query, :foo, "not_in", [])
      q = inspect(query)

      refute q =~ ~r/where:/
    end

    test "updates query properly with `eq` operator and non empty list", %{query: query} do
      query = ListValue.evaluate(query, :foo, "eq", [1, 2])
      q = inspect(query)

      assert q =~ ~r/\w{2}\.foo in \^\[1, 2\]/
    end

    test "updates query properly with `eq` operator and empty list", %{query: query} do
      query = ListValue.evaluate(query, :foo, "eq", [])
      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/false/
    end

    test "updates query properly with `not` operator and non empty list", %{query: query} do
      query = ListValue.evaluate(query, :foo, "not", [1, 2])
      q = inspect(query)

      assert q =~ ~r/is_nil\(\w{2}\.foo\) or \w{2}\.foo not in \^\[1, 2\]/
    end

    test "noop with `not` operator and empty list", %{query: query} do
      query = ListValue.evaluate(query, :foo, "not", [])
      q = inspect(query)

      refute q =~ ~r/where:/
    end

    test "raise error with invalid operator", %{query: query} do
      assert_raise RuntimeError, fn ->
        ListValue.evaluate(query, :foo, "gt", [1, 2])
      end
    end
  end
end
