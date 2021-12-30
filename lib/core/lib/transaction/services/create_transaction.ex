defmodule Core.Transaction.Services.CreateTransaction do
  @moduledoc """
  Service to create a Transaction
  """

  alias Core.Transaction
  alias Core.Schemas

  @spec execute(transaction :: Transaction.Commands.CreateTransaction.t()) :: map()
  def execute(%Transaction.Commands.CreateTransaction{} = create_transaction) do
    %{
      origin_value: create_transaction.value,
      origin_currency: create_transaction.origin_currency,
      final_currency: create_transaction.final_currency,
      convertion_tax: create_transaction.convertion_tax,
      user_id: create_transaction.user_id
    }
    |> Schemas.Transaction.changeset()
    |> Core.Repo.insert!()
  end
end
