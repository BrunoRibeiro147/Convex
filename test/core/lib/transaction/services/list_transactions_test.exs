defmodule Core.Transaction.Services.ListTransactionsTest do
  use Core.DataCase

  alias Core.Schemas
  alias Core.Transactions.Services

  describe "execute/1" do
    setup do
      %{id: user_id} = insert(:user)

      insert_list(2, :transaction, user_id: user_id)

      %{user_id: user_id}
    end

    test "returns a list of Transactions belongs to the user_id", %{user_id: user_id} do
      assert [%Schemas.Transaction{user_id: ^user_id}, %Schemas.Transaction{user_id: ^user_id}] =
               Services.ListTransactions.execute(user_id)
    end

    test "return an empty list if user_id does not have transactions" do
      assert [] = Services.ListTransactions.execute(Ecto.UUID.generate())
    end

    test "return an empty list if user_id was not a UUID" do
      assert [] = Services.ListTransactions.execute("some_uuid")
    end
  end
end
