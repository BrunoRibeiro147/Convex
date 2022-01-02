defmodule Core.Transaction.Services.ListTransactions do
  @moduledoc """
  Service to list Transactions by user_id
  """

  alias Core.Schemas

  @doc """
  Returns a list of `transactions` belongs to the user of `user_id`
  """
  @spec execute(user_id :: Ecto.UUID.t()) :: list(Schemas.Transactions.t())
  def execute(user_id) do
    with {:ok, _} <- cast_user_id(user_id) do
      Schemas.Transaction.Repository.list_by_user_id(user_id)
    end
  end

  defp cast_user_id(user_id) do
    with :error <- Ecto.UUID.cast(user_id) do
      []
    end
  end
end
