defmodule Request do
  use Tesla

  defstruct method: :get, body: :response
end
