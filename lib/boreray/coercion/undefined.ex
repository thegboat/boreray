defmodule Boreray.Coercion.Undefined do
  @moduledoc false

  @type t :: %__MODULE__{
    type: atom,
    value: any,
    op: atom | nil
  }

  defstruct [
    :type,
    :value,
    :op,
  ]
end