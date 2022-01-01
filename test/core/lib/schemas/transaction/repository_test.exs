defmodule Core.Schemas.Transaction.RepositoryTest do
  @moduledoc false

  use Core.DataCase

  alias Core.Schemas.Transaction
  alias Core.Schemas.Transaction.Repository

  describe "list_by_user_id" do
    setup do
      %{id: user_id} = insert(:user)

      insert_list(2, :transaction, user_id: user_id)

      %{user_id: user_id}
    end

    test "returns the transactions belongs to the user_id", %{user_id: user_id} do
      assert [%Transaction{user_id: ^user_id}, %Transaction{user_id: ^user_id}] =
               Repository.list_by_user_id(user_id)
    end
  end
end
