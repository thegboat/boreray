defmodule Boreray.Operation do
  @moduledoc false

  @type t :: %__MODULE__{
          field: atom,
          type: atom,
          op: atom,
          value: any,
          regex: Regex.t() | nil
        }

  defstruct field: nil,
            type: nil,
            op: :eq,
            value: nil,
            regex: nil
end
