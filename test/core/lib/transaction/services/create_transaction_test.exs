defmodule Core.Transaction.Services.CreateTransactionTest do
  use Core.DataCase

  alias Core.Transaction.Commands
  alias Core.Transaction.Services
  alias Core.Schemas

  describe "execute/1" do
    setup do
      %{id: user_id} = insert(:user)

      params = %Commands.CreateTransaction{
        value: 1000,
        origin_currency: "BRL",
        final_currency: "USD",
        convertion_tax: 450,
        user_id: user_id
      }

      %{params: params}
    end

    test "inserts and return Transaction schema if successfull", %{params: params} do
      assert %Schemas.Transaction{id: transaction_id} = Services.CreateTransaction.execute(params)

      assert %Schemas.Transaction{} = Core.Repo.get(Schemas.Transaction, transaction_id)
    end
  end
end
