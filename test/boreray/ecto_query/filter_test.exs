defmodule Boreray.EctoQuery.FilterTest do
  use ExUnit.Case
  require Ecto.Query
  alias Boreray.EctoQuery.Filter

  defmodule FakeResource do
    use Ecto.Schema

    schema "example_table" do
      field(:boolean_field, :boolean)
      field(:string_field, :string)
      field(:integer_field, :float)
      field(:float_field, :integer)
      field(:datetime_field, :utc_datetime_usec)
    end
  end

  setup do
    query = FakeResource.__schema__(:query)
    {:ok, query: Ecto.Query.from(x in Ecto.Query.subquery(query))}
  end

  describe "update/2" do
    test "returns base query when no where clause", %{query: initial} do
      {query, %{}} = Filter.update({initial, %{"filter" =>%{}}}, FakeResource)
      q = inspect(query)

      refute q =~ ~r/where:/
    end

    test "builds a query", %{query: initial} do
      {query, %{}} =
        Filter.update({initial, %{"filter" =>%{
          "boolean_field" => %{"eq" => "true"},
          "string_field" => %{"eq" => "astring"},
          "integer_field" => %{"eq" => 5},
          "float_field" => %{"eq" => 5.0},
          "datetime_field" => %{"gt" => "2020-01-01T01:01:01"}
        }}}, FakeResource)

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/\w{2}\.boolean_field == \^true/
      assert q =~ ~r/\w{2}\.string_field == \^"astring"/
      assert q =~ ~r/\w{2}\.integer_field == \^5/
      assert q =~ ~r/\w{2}\.float_field == \^5.0/

      assert q =~
               ~r/\w{2}\.datetime_field > fragment\("TO_TIMESTAMP\(\?, 'YYYY-MM-DD HH24:MI:SS'\)", \^"2020-01-01 01:01:01"\)/
    end

    test "returns an error for invalid fields", %{query: initial} do
      assert_raise RuntimeError, fn ->
        Filter.update({initial, %{"filter" =>%{
          "invalid" => %{"eq" => "true"},
          "string_field" => %{"eq" => "astring"}
        }}}, FakeResource)
      end
    end

    test "applies `eq` -> nil filter", %{query: initial} do
      {query, %{}} =
        Filter.update({initial, %{"filter" =>%{
          "datetime_field" => %{"eq" => nil}
        }}}, FakeResource)

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/is_nil\(\w{2}\.datetime_field\)/
    end

    test "applies `like` filter", %{query: initial} do
      {query, %{}} =
        Filter.update({initial, %{"filter" =>%{
          "string_field" => %{"like" => "astring"}
        }}}, FakeResource)

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/fragment\("REGEXP_LIKE\(\?, \?, 'in'\)", \w{2}.string_field, \^"astring"\)/
    end

    test "applies `not_like` filter", %{query: initial} do
      {query, %{}} =
        Filter.update({initial, %{"filter" =>%{
          "string_field" => %{"not_like" => "astring"}
        }}}, FakeResource)

      q = inspect(query)

      assert q =~ ~r/where:/

      assert q =~
               ~r/is_nil\(\w{2}.string_field\) or fragment\("NOT REGEXP_LIKE\(\?, \?, 'in'\)", \w{2}.string_field, \^"astring"\)/
    end

    test "applies `not` filter", %{query: initial} do
      {query, %{}} =
        Filter.update({initial, %{"filter" =>%{
          "integer_field" => %{"not" => 5}
        }}}, FakeResource)

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/is_nil\(\w{2}.integer_field\) or \w{2}\.integer_field != \^5/
    end

    test "applies greater than filter", %{query: initial} do
      {query, %{}} =
        Filter.update({initial, %{"filter" =>%{
          "integer_field" => %{"gt" => 5}
        }}}, FakeResource)

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/\w{2}\.integer_field > \^5/
    end

    test "applies less than filter", %{query: initial} do
      {query, %{}} =
        Filter.update({initial, %{"filter" =>%{
          "integer_field" => %{"lt" => 5}
        }}}, FakeResource)

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/\w{2}\.integer_field < \^5/
    end

    test "applies greater than or equal to filter", %{query: initial} do
      {query, %{}} =
        Filter.update({initial, %{"filter" =>%{
          "integer_field" => %{"gte" => 5}
        }}}, FakeResource)

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/\w{2}\.integer_field >= \^5/
    end

    test "applies less than or equal to filter", %{query: initial} do
      {query, %{}} =
        Filter.update({initial, %{"filter" =>%{
          "integer_field" => %{"lte" => 5}
        }}}, FakeResource)

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/\w{2}\.integer_field <= \^5/
    end

    test "applies not null filter", %{query: initial} do
      {query, %{}} =
        Filter.update({initial, %{"filter" =>%{
          "integer_field" => %{"not" => nil}
        }}}, FakeResource)

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/not is_nil\(\w{2}\.integer_field\)/
    end

    test "applies is null filter", %{query: initial} do
      {query, %{}} =
        Filter.update({initial, %{"filter" =>%{
          "integer_field" => %{"eq" => nil}
        }}}, FakeResource)

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/is_nil\(\w{2}\.integer_field\)/
    end

    test "handles compound Filter", %{query: initial} do
      {query, %{}} =
        Filter.update({initial, %{"filter" =>%{
          "integer_field" => %{"gt" => 2, "lte" => 29}
        }}}, FakeResource)

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/\w{2}\.integer_field > \^2/
      assert q =~ ~r/\w{2}\.integer_field <= \^29/
    end

    test "raise error with invalid operator", %{query: initial} do
      assert_raise RuntimeError, fn ->
        Filter.update({initial, %{"filter" =>%{
          "integer_field" => %{"invalid" => 2, "lte" => 29}
        }}}, FakeResource)
      end
    end
  end
end
