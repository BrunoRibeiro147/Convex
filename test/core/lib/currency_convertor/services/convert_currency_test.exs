defmodule Core.CurrencyConvertor.Services.ConvertCurrencyTest do
  use Core.DataCase
  import Hammox

  alias Core.CurrencyConvertor.Commands
  alias Core.CurrencyConvertor.Services

  describe "execute/1" do
    setup do
      params = %Commands.ConvertCurrency{
        final_currency: "BRL",
        value: 10.0
      }

      %{params: params}
    end

    test "get the convertion tax for the currency and the converted_value", %{params: params} do
      expect(Core.Adapters.FetchConvertionTax.ExchangeRates.Mock, :fetch_convertion_tax, fn _ ->
        {:ok, 6.31}
      end)

      assert {:ok,
              %Commands.ConvertCurrency{
                converted_value: "R$ 63,10",
                convertion_tax: 6.31,
                final_currency: "BRL",
                value: 10.0
              }} = Services.ConvertCurrency.execute(params)
    end

    test "returns an error in case the api request fails", %{params: params} do
      expect(Core.Adapters.FetchConvertionTax.ExchangeRates.Mock, :fetch_convertion_tax, fn _ ->
        {:error, "Occur an error while fetch api, try again"}
      end)

      assert {:error, "Occur an error while fetch api, try again"} =
               Services.ConvertCurrency.execute(params)
    end
  end
end
