defmodule Core.Factory do
  @moduledoc """
  Core applications factories (ExMachina)
  """

  use ExMachina.Ecto, repo: Core.Repo
  use Core.Factories.User
  use Core.Factories.Transaction
end
