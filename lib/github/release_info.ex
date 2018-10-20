defmodule RaRn.ReleaseInfo do
  @type t :: %__MODULE__{
          tag: String.t(),
          url: String.t(),
          cursor: String.t()
        }
  defstruct [
    :tag,
    :url,
    :cursor
  ]
end
