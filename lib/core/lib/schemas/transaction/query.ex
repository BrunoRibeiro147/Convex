defmodule Core.Schemas.Transaction.Query do
  @moduledoc """
  Query module for Transaction
  """

  import Ecto.Query

  @spec by_user_id(queryable :: Ecto.Queryable.t(), user_id :: Ecto.UUID.t()) ::
          Ecto.Queryable.t()
  def by_user_id(queryable, user_id),
    do: where(queryable, [transaction: tn], tn.user_id == ^user_id)
end
