defmodule Boreray.EctoQuery.Filter.StringFieldTest do
  use ExUnit.Case
  require Ecto.Query
  alias Boreray.EctoQuery.Filter.StringField

  setup do
    {:ok, query: Ecto.Query.from(x in "example_table")}
  end

  describe "evaluate/4" do
    test "updates query properly when operator is `like`", %{query: query} do
      query = StringField.evaluate(query, :foo, :like, "astring")
      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/fragment\("REGEXP_LIKE\(\?, \?, 'mc'\)", \w{2}.foo, \^"astring"\)/
    end

    test "updates query properly when operator is `not_like`", %{query: query} do
      query = StringField.evaluate(query, :foo, :not_like, "astring")
      q = inspect(query)

      assert q =~ ~r/where:/

      assert q =~
               ~r/is_nil\(\w{2}.foo\) or fragment\("NOT REGEXP_LIKE\(\?, \?, 'mc'\)", \w{2}.foo, \^"astring"\)/
    end

    test "updates query properly when operator is `ilike`", %{query: query} do
      query = StringField.evaluate(query, :foo, :ilike, "astring")
      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/fragment\("REGEXP_LIKE\(\?, \?, 'mi'\)", \w{2}.foo, \^"astring"\)/
    end

    test "updates query properly when operator is `not_ilike`", %{query: query} do
      query = StringField.evaluate(query, :foo, :not_ilike, "astring")
      q = inspect(query)

      assert q =~ ~r/where:/

      assert q =~
               ~r/is_nil\(\w{2}.foo\) or fragment\("NOT REGEXP_LIKE\(\?, \?, 'mi'\)", \w{2}.foo, \^"astring"\)/
    end
  end
end
