defmodule Boreray.SchemaTest do
  use ExUnit.Case

  alias Boreray.EctoQuery
  alias Boreray.Schema

  defmodule FieldInfoDefined do
    def __field_info__ do
      [
        field1: :string,
        field2: :integer
      ]
    end
  end

  defmodule EctoSchemaResource do
    use Ecto.Schema

    schema "table" do
      field(:integer_field, :integer)
      field(:float_field, :float)
      field(:boolean_field, :boolean)
      field(:string_field, :string)
      field(:binary_field, :binary)
      field(:decimal_field, :decimal)
      field(:id_field, :id)
      field(:binary_id_field, :binary_id)
      field(:utc_datetime_field, :utc_datetime)
      field(:naive_datetime_field, :naive_datetime)
      field(:date_field, :date)
      field(:utc_datetime_usec_field, :utc_datetime_usec)
      field(:naive_datetime_usec_field, :naive_datetime_usec)
    end
  end

  describe "build/2" do
    test "can build schema from Keyword list" do
      assert %{
               field1: :string,
               field2: :integer
             } == Schema.build([field1: "string", field2: "integer"], EctoQuery.types())
    end

    test "can build schema from map" do
      assert %{
               field1: :string,
               field2: :integer
             } == Schema.build(%{field1: "string", field2: "integer"}, EctoQuery.types())
    end

    test "can build schema from list of tuple pairs" do
      assert %{
               field1: :string,
               field2: :integer
             } == Schema.build([{"field1", "string"}, {"field2", "integer"}], EctoQuery.types())
    end

    test "can build schema from module with `__field_info__/0` defined" do
      assert %{
               field1: :string,
               field2: :integer
             } == Schema.build(FieldInfoDefined, EctoQuery.types())
    end

    test "can build schema from module with Ecto Schema `__schema__` behavior" do
      assert %{
               string_field: :string,
               integer_field: :integer
             } = Schema.build(EctoSchemaResource, EctoQuery.types())
    end
  end
end
