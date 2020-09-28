defmodule AtriaPower.RandomTemparature do
  @moduledoc """
  It is used to generate a random temparature values.
  """
  @doc false
  def generate() do
    :rand.uniform()
    |> Kernel.*(100)
    |> Float.round(2)
  end
end
