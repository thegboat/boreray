defmodule Boreray.List.FilterTest do
  use ExUnit.Case
  alias Boreray.List.Filter
  alias Boreray.Operation

  defmodule FakeResource do
    use Ecto.Schema

    schema "example_table" do
      field(:boolean_field, :boolean)
      field(:string_field, :string)
      field(:integer_field, :integer)
      field(:float_field, :float)
      field(:decimal_field, :decimal)
      field(:datetime_field, :utc_datetime_usec)
    end
  end

  setup do
    list = [
      new_resource(true, "resource1", 1, 10.01, DateTime.new!(~D[2016-05-24], ~T[13:26:08.000], "Etc/UTC"), Decimal.from_float(10.01)),
      new_resource(false, "resource2", 2, 20.01, DateTime.new!(~D[2016-06-24], ~T[13:26:08.000], "Etc/UTC"), Decimal.from_float(20.01)),
      new_resource(true, "resource3", 3, 30.01, DateTime.new!(~D[2016-07-24], ~T[13:26:08.000], "Etc/UTC"), Decimal.from_float(30.01))
    ]
    {:ok, list: list}
  end

  describe "update/2 :string" do
    test ":eq", %{list: list} do
      operation = new_op(:eq, "resource1", :string_field, :string)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{string_field: "resource1"}] = updated
    end

    test ":gt", %{list: list} do
      operation = new_op(:gt, "resource2", :string_field, :string)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{string_field: "resource3"}] = updated
    end

    test ":gte", %{list: list} do
      operation = new_op(:gte, "resource3", :string_field, :string)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{string_field: "resource3"}] = updated
    end

    test ":lt", %{list: list} do
      operation = new_op(:lt, "resource2", :string_field, :string)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{string_field: "resource1"}] = updated
    end

    test ":lte", %{list: list} do
      operation = new_op(:lte, "resource1", :string_field, :string)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{string_field: "resource1"}] = updated
    end

    test ":like", %{list: list} do
      operation = new_op(:like, "2$", :string_field, :string, Regex.compile!("2$"))
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{string_field: "resource2"}] = updated

      operation = new_op(:like, "E2$", :string_field, :string, Regex.compile!("E2$"))
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [] = updated
    end

    test ":not_like", %{list: list} do
      operation = new_op(:not_like, "2$", :string_field, :string, Regex.compile!("2$", "m"))
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{string_field: "resource1"}, %{string_field: "resource3"}] = updated

      operation = new_op(:not_like, "E2$", :string_field, :string, Regex.compile!("E2$", "m"))
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{}, %{}, %{}] = updated
    end

    test ":ilike", %{list: list} do
      operation = new_op(:ilike, "E2$", :string_field, :string, Regex.compile!("E2$", "im"))
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{string_field: "resource2"}] = updated
    end

    test ":not_ilike", %{list: list} do
      operation = new_op(:not_ilike, "E2$", :string_field, :string, Regex.compile!("E2$", "im"))
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{string_field: "resource1"}, %{string_field: "resource3"}] = updated
    end
  end

  describe "update/2 :integer" do
    test ":eq", %{list: list} do
      operation = new_op(:eq, Decimal.from_float(1.0), :integer_field, :integer)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{integer_field: 1}] = updated
    end

    test ":not", %{list: list} do
      operation = new_op(:not, Decimal.from_float(1.0), :integer_field, :integer)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{integer_field: 2}, %{integer_field: 3}] = updated
    end

    test ":gt", %{list: list} do
      operation = new_op(:gt, Decimal.from_float(2.0), :integer_field, :integer)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{integer_field: 3}] = updated
    end

    test ":gte", %{list: list} do
      operation = new_op(:gte, Decimal.from_float(3.0), :integer_field, :integer)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{integer_field: 3}] = updated
    end

    test ":lt", %{list: list} do
      operation = new_op(:lt, Decimal.from_float(2.0), :integer_field, :integer)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{integer_field: 1}] = updated
    end

    test ":lte", %{list: list} do
      operation = new_op(:lte, Decimal.from_float(1.0), :integer_field, :integer)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{integer_field: 1}] = updated
    end
  end

  describe "update/2 :boolean" do
    test ":eq", %{list: list} do
      operation = new_op(:eq, true, :boolean_field, :boolean)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{integer_field: 1}, %{integer_field: 3}] = updated
    end

    test ":not", %{list: list} do
      operation = new_op(:not, true, :boolean_field, :boolean)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{integer_field: 2}] = updated
    end
  end

  describe "update/2 :float" do
    test ":eq", %{list: list} do
      operation = new_op(:eq, Decimal.from_float(10.01), :float_field, :float)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{float_field: 10.01}] = updated
    end

    test ":not", %{list: list} do
      operation = new_op(:not, Decimal.from_float(10.01), :float_field, :float)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{float_field: 20.01}, %{float_field: 30.01}] = updated
    end

    test ":gt", %{list: list} do
      operation = new_op(:gt, Decimal.from_float(20.01), :float_field, :float)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{float_field: 30.01}] = updated
    end

    test ":gte", %{list: list} do
      operation = new_op(:gte, Decimal.from_float(30.01), :float_field, :float)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{float_field: 30.01}] = updated
    end

    test ":lt", %{list: list} do
      operation = new_op(:lt, Decimal.from_float(20.01), :float_field, :float)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{float_field: 10.01}] = updated
    end

    test ":lte", %{list: list} do
      operation = new_op(:lte, Decimal.from_float(10.01), :float_field, :float)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{float_field: 10.01}] = updated
    end
  end

  describe "update/2 :decimal" do
    test ":eq", %{list: list} do
      operation = new_op(:eq, Decimal.from_float(10.01), :decimal_field, :decimal)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{float_field: 10.01}] = updated
    end

    test ":not", %{list: list} do
      operation = new_op(:not, Decimal.from_float(10.01), :decimal_field, :decimal)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{float_field: 20.01}, %{float_field: 30.01}] = updated
    end

    test ":gt", %{list: list} do
      operation = new_op(:gt, Decimal.from_float(20.01), :decimal_field, :decimal)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{float_field: 30.01}] = updated
    end

    test ":gte", %{list: list} do
      operation = new_op(:gte, Decimal.from_float(30.01), :decimal_field, :decimal)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{float_field: 30.01}] = updated
    end

    test ":lt", %{list: list} do
      operation = new_op(:lt, Decimal.from_float(20.01), :decimal_field, :decimal)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{float_field: 10.01}] = updated
    end

    test ":lte", %{list: list} do
      operation = new_op(:lte, Decimal.from_float(10.01), :decimal_field, :decimal)
      updated = list
      |> Filter.update(%{filter: [operation]})
      |> Enum.into([])

      assert [%{float_field: 10.01}] = updated
    end
  end

  defp new_resource(bool, str, int, float, date, dec) do
    %FakeResource{
      boolean_field: bool,
      string_field: str,
      integer_field: int,
      float_field: float,
      decimal_field: dec,
      datetime_field: date
    }
  end

  defp new_op(op, value, field, type) do
    new_op(op, value, field, type, nil)
  end

  defp new_op(op, value, field, type, regex) do
    %Operation{
      op: op,
      value: value,
      field: field,
      type: type,
      regex: regex
    }
  end
end
