defmodule Boreray.Operation do
  @moduledoc false

  @type t :: %__MODULE__{
          field: atom,
          type: atom,
          op: atom,
          value: any
        }

  defstruct field: nil,
            type: nil,
            op: :eq,
            value: nil
end
