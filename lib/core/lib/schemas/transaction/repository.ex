defmodule Core.Schemas.Transaction.Repository do
  @moduledoc """
  Repository module for Transaction
  """

  alias Core.Schemas
  import Ecto.Query

  @spec list_by_user_id(user_id :: Ecto.UUID.t()) :: transactions :: list(Schemas.Transaction.t())
  def list_by_user_id(user_id) do
    from(tn in Schemas.Transaction, as: :transaction, select: tn)
    |> Schemas.Transaction.Query.by_user_id(user_id)
    |> Core.Repo.all()
  end
end
