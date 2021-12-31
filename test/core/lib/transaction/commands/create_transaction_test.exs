defmodule Core.Transaction.Commands.CreateTransactionTest do
  use Core.DataCase

  alias Core.Transaction.Commands

  describe "changeset/2" do
    setup do
      params = %{
        origin_currency: "BRL",
        final_currency: "USD",
        value: 1000,
        convertion_tax: 450,
        user_id: Ecto.UUID.generate()
      }

      %{params: params}
    end

    test "returns a valid changeset if all params are valid", %{params: params} do
      assert %Ecto.Changeset{valid?: true} = Commands.CreateTransaction.changeset(params)
    end

    for field <- [:final_currency, :convertion_tax] do
      test "returns an invalid changeset if #{field} currency is not allowed", %{params: params} do
        assert %Ecto.Changeset{valid?: false} =
                 params
                 |> Map.put(unquote(field), "test")
                 |> Commands.CreateTransaction.changeset()
      end
    end

    test "returns an invalid changeset if user_id was not an UUID", %{params: params} do
      assert %Ecto.Changeset{valid?: false} =
               params
               |> Map.put(:user_id, "Not an UUID")
               |> Commands.CreateTransaction.changeset()
    end
  end
end
