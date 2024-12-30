# defmodule Boreray.ParamsTest do
#   use ExUnit.Case

#   alias Boreray.Params

#   describe "normalize/1" do
#     test "converts Keyword list to expected map" do
#       arg = [field: "value"]
#       assert %{filter: %{field: %{eq: "value"}}} = Params.normalize(arg)
#     end

#     test "converts simple value to operation map" do
#       arg = %{"filter" => %{"field" => "value"}}
#       assert %{filter: %{field: %{eq: "value"}}} = Params.normalize(arg)
#     end

#     test "applies default values" do
#       assert %{filter: %{field: %{eq: "value"}}} = Params.normalize(arg)
#     end

#     test "converts single value operation to list equivalent" do
#       arg = %{"filter" => %{"field" => %{"eq" => [1, 2]}}}
#       assert %{filter: %{field: %{in: [1, 2]}}} = Params.normalize(arg)
#       arg = %{"filter" => %{"field" => %{"is" => [1, 2]}}}
#       assert %{filter: %{field: %{in: [1, 2]}}} = Params.normalize(arg)

#       arg = %{"filter" => %{"field" => %{"not" => [1, 2]}}}
#       assert %{filter: %{field: %{not_in: [1, 2]}}} = Params.normalize(arg)
#       arg = %{"filter" => %{"field" => %{"is_not" => [1, 2]}}}
#       assert %{filter: %{field: %{not_in: [1, 2]}}} = Params.normalize(arg)
#     end

#     test "converts `is` operation to IS NULL" do
#       arg = %{"filter" => %{"field" => %{"is" => "NULL"}}}
#       assert %{filter: %{field: %{eq: nil}}} = Params.normalize(arg)

#       arg = %{"filter" => %{"field" => %{"is" => "null"}}}
#       assert %{filter: %{field: %{eq: nil}}} = Params.normalize(arg)

#       arg = %{"filter" => %{"field" => %{"is" => "nil"}}}
#       assert %{filter: %{field: %{eq: nil}}} = Params.normalize(arg)
#     end

#     test "converts `is_not` operation to IS NOT NULL" do
#       arg = %{"filter" => %{"field" => %{"is_not" => "NULL"}}}
#       assert %{filter: %{field: %{not: nil}}} = Params.normalize(arg)

#       arg = %{"filter" => %{"field" => %{"is_not" => "null"}}}
#       assert %{filter: %{field: %{not: nil}}} = Params.normalize(arg)

#       arg = %{"filter" => %{"field" => %{"is_not" => "nil"}}}
#       assert %{filter: %{field: %{not: nil}}} = Params.normalize(arg)
#     end

#     test "converts `is` to `eq` when is not special null cases" do
#       arg = %{"filter" => %{"field" => %{"is" => "Null"}}}
#       assert %{filter: %{field: %{eq: "Null"}}} = Params.normalize(arg)

#       arg = %{"filter" => %{"field" => %{"is" => 1}}}
#       assert %{filter: %{field: %{eq: 1}}} = Params.normalize(arg)
#     end

#     test "converts `is_not` to `not` when is not special null cases" do
#       arg = %{"filter" => %{"field" => %{"is_not" => "Null"}}}
#       assert %{filter: %{field: %{not: "Null"}}} = Params.normalize(arg)

#       arg = %{"filter" => %{"field" => %{"is_not" => 1}}}
#       assert %{filter: %{field: %{not: 1}}} = Params.normalize(arg)
#     end
#   end
# end
