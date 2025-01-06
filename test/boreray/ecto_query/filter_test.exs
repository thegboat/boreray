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
    {:ok, query: query}
  end

  describe "update/2" do
    test "returns base query when no where clause", %{query: initial} do
      query = Filter.update(initial, %{filter: []})
      q = inspect(query)

      refute q =~ ~r/where:/
    end

    test "builds a query", %{query: initial} do
      query =
        Filter.update(initial, %{
          filter: [
            %{field: :boolean_field, type: :boolean, op: :eq, value: "true"},
            %{field: :string_field, type: :string, op: :eq, value: "astring"},
            %{field: :integer_field, type: :integer, op: :eq, value: 5},
            %{field: :float_field, type: :float, op: :eq, value: 5.0},
            %{field: :datetime_field, type: :datetime, op: :gt, value: "2020-01-01 01:01:01"}
          ]
        })

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/\w{2}\.boolean_field == \^true/
      assert q =~ ~r/\w{2}\.string_field == \^"astring"/
      assert q =~ ~r/\w{2}\.integer_field == \^5/
      assert q =~ ~r/\w{2}\.float_field == \^5.0/

      assert q =~
               ~r/\w{2}\.datetime_field > fragment\("TO_TIMESTAMP\(\?, 'YYYY-MM-DD HH24:MI:SS'\)", \^"2020-01-01 01:01:01"\)/
    end

    test "applies `eq` -> nil filter", %{query: initial} do
      query =
        Filter.update(initial, %{
          filter: [
            %{field: :datetime_field, type: :utc_datetime_usec, op: :eq, value: nil}
          ]
        })

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/is_nil\(\w{2}\.datetime_field\)/
    end

    test "applies `like` filter", %{query: initial} do
      query =
        Filter.update(initial, %{
          filter: [
            %{field: :string_field, type: :string, op: :like, value: "astring"}
          ]
        })

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/fragment\("REGEXP_LIKE\(\?, \?, 'mc'\)", \w{2}.string_field, \^"astring"\)/
    end

    test "applies `not_like` filter", %{query: initial} do
      query =
        Filter.update(initial, %{
          filter: [
            %{field: :string_field, type: :string, op: :not_like, value: "astring"}
          ]
        })

      q = inspect(query)

      assert q =~ ~r/where:/

      assert q =~
               ~r/is_nil\(\w{2}.string_field\) or fragment\("NOT REGEXP_LIKE\(\?, \?, 'mc'\)", \w{2}.string_field, \^"astring"\)/
    end

    test "applies `ilike` filter", %{query: initial} do
      query =
        Filter.update(initial, %{
          filter: [
            %{field: :string_field, type: :string, op: :ilike, value: "astring"}
          ]
        })

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/fragment\("REGEXP_LIKE\(\?, \?, 'mi'\)", \w{2}.string_field, \^"astring"\)/
    end

    test "applies `not_ilike` filter", %{query: initial} do
      query =
        Filter.update(initial, %{
          filter: [
            %{field: :string_field, type: :string, op: :not_ilike, value: "astring"}
          ]
        })

      q = inspect(query)

      assert q =~ ~r/where:/

      assert q =~
               ~r/is_nil\(\w{2}.string_field\) or fragment\("NOT REGEXP_LIKE\(\?, \?, 'mi'\)", \w{2}.string_field, \^"astring"\)/
    end

    test "applies `not` filter", %{query: initial} do
      query =
        Filter.update(initial, %{
          filter: [
            %{field: :integer_field, type: :integer, op: :not, value: 5}
          ]
        })

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/is_nil\(\w{2}.integer_field\) or \w{2}\.integer_field != \^5/
    end

    test "applies greater than filter", %{query: initial} do
      query =
        Filter.update(initial, %{
          filter: [
            %{field: :integer_field, type: :integer, op: :gt, value: 5}
          ]
        })

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/\w{2}\.integer_field > \^5/
    end

    test "applies less than filter", %{query: initial} do
      query =
        Filter.update(initial, %{
          filter: [
            %{field: :integer_field, type: :integer, op: :lt, value: 5}
          ]
        })

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/\w{2}\.integer_field < \^5/
    end

    test "applies greater than or equal to filter", %{query: initial} do
      query =
        Filter.update(initial, %{
          filter: [
            %{field: :integer_field, type: :integer, op: :gte, value: 5}
          ]
        })

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/\w{2}\.integer_field >= \^5/
    end

    test "applies less than or equal to filter", %{query: initial} do
      query =
        Filter.update(initial, %{
          filter: [
            %{field: :integer_field, type: :integer, op: :lte, value: 5}
          ]
        })

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/\w{2}\.integer_field <= \^5/
    end

    test "applies not null filter", %{query: initial} do
      query =
        Filter.update(initial, %{
          filter: [
            %{field: :integer_field, type: :integer, op: :not, value: nil}
          ]
        })

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/not is_nil\(\w{2}\.integer_field\)/
    end

    test "applies is null filter", %{query: initial} do
      query =
        Filter.update(initial, %{
          filter: [
            %{field: :integer_field, type: :integer, op: :eq, value: nil}
          ]
        })

      q = inspect(query)

      assert q =~ ~r/where:/
      assert q =~ ~r/is_nil\(\w{2}\.integer_field\)/
    end
  end
end
