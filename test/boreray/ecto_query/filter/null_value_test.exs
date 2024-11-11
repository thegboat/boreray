defmodule Boreray.EctoQuery.Filter.NullValueTest do
  use ExUnit.Case
  require Ecto.Query
  alias Boreray.EctoQuery.Filter.NullValue

  setup do
    {:ok, query: Ecto.Query.from(x in "example_table")}
  end

  describe "evaluate/3" do
    test "updates query with `is null` when operator is `eq`", %{query: query} do
      query = NullValue.evaluate(query, :foo, "eq")
      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/is_nil\(\w{2}\.foo\)/
    end

    test "updates query with `not null` when operator is `not`", %{query: query} do
      query = NullValue.evaluate(query, :foo, "not")
      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/not is_nil\(\w{2}\.foo\)/
    end

    test "updates query to force failure when operator is neither `not` or `eq`", %{query: query} do
      query = NullValue.evaluate(query, :foo, "lt")
      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/false/
    end
  end
end
