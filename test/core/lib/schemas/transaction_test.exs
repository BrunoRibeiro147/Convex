defmodule Core.Schemas.TransactionTest do
  use Core.DataCase
  alias Core.Schemas

  describe "changeset/2" do
    setup do
      %{id: user_id} = insert(:user)

      params = %{
        origin_value: 1000,
        origin_currency: "BRL",
        final_currency: "USD",
        convertion_tax: 450,
        user_id: user_id
      }

      %{params: params}
    end

    test "returns an valid changeset if all params are valid", %{params: params} do
      assert %Ecto.Changeset{valid?: true} = Schemas.Transaction.changeset(params)
    end

    test "insert a transaction with valid changeset", %{params: params} do
      assert {:ok, %Schemas.Transaction{}} =
               params
               |> Schemas.Transaction.changeset()
               |> Core.Repo.insert()
    end

    for field <- [:origin_value, :origin_currency, :final_currency, :convertion_tax, :user_id] do
      test "returns an invalid changeset if #{field} was missind", %{params: params} do
        assert %Ecto.Changeset{valid?: false} =
                 params
                 |> Map.drop([unquote(field)])
                 |> Schemas.Transaction.changeset()
      end
    end
  end
end
