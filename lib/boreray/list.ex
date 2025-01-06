defmodule Boreray.List do
  @moduledoc false
  alias Boreray.Planner
  alias Boreray.Schema

  def build(module, list, params) do
    schema = Schema.build(module, types())
    plan = Planner.build_plan(params, schema)
    do_build(list, plan)
  end

  def types do
    %{
      "integer" => :integer,
      "float" => :decimal,
      "boolean" => :boolean,
      "string" => :string,
      "binary" => :string,
      "decimal" => :decimal,
      "id" => :integer,
      "binary_id" => :string,
      "utc_datetime" => :datetime,
      "naive_datetime" => :datetime,
      "date" => :datetime,
      "utc_datetime_usec" => :datetime,
      "naive_datetime_usec" => :datetime,
      "array" => :array,
      "time" => :time,
      "time_usec" => :time
    }
  end

  defp do_build(list, plan) do
    list
    |> __MODULE__.Filter.update(plan)
    |> __MODULE__.Sort.update(plan)
    |> __MODULE__.Pagination.update(plan)
    |> Enum.into([])
  end
end