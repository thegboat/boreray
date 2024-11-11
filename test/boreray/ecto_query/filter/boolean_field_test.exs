defmodule Boreray.EctoQuery.Filter.BooleanFieldTest do
  use ExUnit.Case
  require Ecto.Query
  alias Boreray.EctoQuery.Filter.BooleanField

  setup do
    {:ok, query: Ecto.Query.from(x in "example_table")}
  end

  describe "evaluate/4" do
    test "updates query properly when operator is `eq` and castable value is true", %{query: query} do
      query = BooleanField.evaluate(query, :foo, "eq", true)
      q = inspect(query)
      assert q =~ ~r/where:/
      assert q =~ ~r/\w{2}\.foo == \^true/

      query = BooleanField.evaluate(query, :foo, "eq", "TrUe")
      q = inspect(query)
      assert q =~ ~r/\w{2}\.foo == \^true/

      query = BooleanField.evaluate(query, :foo, "eq", "T")
      q = inspect(query)
      assert q =~ ~r/\w{2}\.foo == \^true/

      query = BooleanField.evaluate(query, :foo, "eq", "1")
      q = inspect(query)
      assert q =~ ~r/\w{2}\.foo == \^true/
    end

    test "updates query properly when operator is `eq` and castable value is false", %{query: query} do
      query = BooleanField.evaluate(query, :foo, "eq", false)
      q = inspect(query)
      assert q =~ ~r/where:/
      assert q =~ ~r/\w{2}\.foo == \^false/

      query = BooleanField.evaluate(query, :foo, "eq", "False")
      q = inspect(query)
      assert q =~ ~r/\w{2}\.foo == \^false/

      query = BooleanField.evaluate(query, :foo, "eq", "F")
      q = inspect(query)
      assert q =~ ~r/\w{2}\.foo == \^false/

      query = BooleanField.evaluate(query, :foo, "eq", "0")
      q = inspect(query)
      assert q =~ ~r/\w{2}\.foo == \^false/
    end

    test "updates query properly when operator is `not` and castable value is true", %{query: query} do
      query = BooleanField.evaluate(query, :foo, "not", true)
      q = inspect(query)
      assert q =~ ~r/where:/
      assert q =~ ~r/\w{2}\.foo != \^true/

      query = BooleanField.evaluate(query, :foo, "not", "TrUe")
      q = inspect(query)
      assert q =~ ~r/\w{2}\.foo != \^true/

      query = BooleanField.evaluate(query, :foo, "not", "T")
      q = inspect(query)
      assert q =~ ~r/\w{2}\.foo != \^true/

      query = BooleanField.evaluate(query, :foo, "not", "1")
      q = inspect(query)
      assert q =~ ~r/\w{2}\.foo != \^true/
    end

    test "updates query properly when operator is `not` and castable value is false", %{query: query} do
      query = BooleanField.evaluate(query, :foo, "not", false)
      q = inspect(query)
      assert q =~ ~r/where:/
      assert q =~ ~r/\w{2}\.foo != \^false/

      query = BooleanField.evaluate(query, :foo, "not", "False")
      q = inspect(query)
      assert q =~ ~r/\w{2}\.foo != \^false/

      query = BooleanField.evaluate(query, :foo, "not", "F")
      q = inspect(query)
      assert q =~ ~r/\w{2}\.foo != \^false/

      query = BooleanField.evaluate(query, :foo, "not", "0")
      q = inspect(query)
      assert q =~ ~r/\w{2}\.foo != \^false/
    end

    test "raise error with uncastable value", %{query: query} do
      assert_raise RuntimeError, fn ->
        BooleanField.evaluate(query, :foo, "not", "grady")
      end
    end

    test "raise error with invalid operator", %{query: query} do
      assert_raise RuntimeError, fn ->
        BooleanField.evaluate(query, :foo, "in", true)
      end
    end
  end
end
