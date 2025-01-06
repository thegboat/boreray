defmodule Boreray.Plan do
  @moduledoc false

  alias Boreray.Operation

  @type t :: %__MODULE__{
          filters: list(Operation.t()),
          sort: nil | atom,
          sort_type: nil | atom,
          sort_dir: :asc | :desc,
          limit: nil | integer,
          page: integer,
          errors: list(String.t())
        }

  defstruct filters: [],
            sort: nil,
            sort_type: nil,
            sort_dir: :asc,
            limit: nil,
            page: 1,
            errors: []
end
