defmodule Core.CurrencyConvertor.Services.ConvertCurrency do
  @moduledoc """
  Service to calculate the currency convertion
  """

  alias Core.CurrencyConvertor
  alias Core.Ports
  alias Core.Utils

  @spec execute(convert_currency :: CurrencyConvertor.Commands.ConvertCurrency.t()) ::
          {:ok, CurrencyConvertor.Commands.ConvertCurrency.t()} | {:error, reason :: term()}
  def execute(
        %CurrencyConvertor.Commands.ConvertCurrency{
          final_currency: final_currency,
          value: value
        } = convert_currency
      ) do
    with {:ok, convert_tax} <- Ports.FetchConvertionTax.fetch_convertion_tax(final_currency) do
      convertion_tax_with_precision = Utils.Format.format_value_with_precision(convert_tax, 2)

      converted_value =
        convertion_tax_with_precision
        |> Decimal.mult(Decimal.from_float(value))
        |> Number.Currency.number_to_currency(Utils.Format.format_currency(final_currency))

      {:ok,
       convert_currency
       |> Map.put(:convertion_tax, Decimal.to_float(convertion_tax_with_precision))
       |> Map.put(:converted_value, converted_value)}
    end
  end
end
