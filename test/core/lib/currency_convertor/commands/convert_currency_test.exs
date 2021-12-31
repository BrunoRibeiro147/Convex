defmodule Core.CurrencyConvertor.Commands.ConvertCurrencyTest do
  use Core.DataCase

  alias Core.CurrencyConvertor.Commands.ConvertCurrency

  describe "changeset/2" do
    setup do
      params = %{
        final_currency: "USD",
        value: 1000
      }

      %{params: params}
    end

    test "returns a valid changeset if all params are valid", %{params: params} do
      assert %Ecto.Changeset{valid?: true} = ConvertCurrency.changeset(params)
    end

    for field <- [:final_currency] do
      test "returns an invalid changeset if #{field} currency is not allowed", %{params: params} do
        assert %Ecto.Changeset{valid?: false} =
                 params
                 |> Map.put(unquote(field), "test")
                 |> ConvertCurrency.changeset()
      end
    end
  end
end
