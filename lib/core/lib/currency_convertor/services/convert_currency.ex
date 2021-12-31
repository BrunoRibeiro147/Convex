defmodule Core.CurrencyConvertor.Services.ConvertCurrency do
  @moduledoc """
  Service to calculate the currency convertion
  """

  alias Core.CurrencyConvertor
  alias Core.Ports

  @spec execute(convert_currency :: CurrencyConvertor.Commands.ConvertCurrency.t()) ::
          {:ok, CurrencyConvertor.Commands.ConvertCurrency.t()} | {:error, reason :: term()}
  def execute(
        %CurrencyConvertor.Commands.ConvertCurrency{
          final_currency: final_currency,
          value: value
        } = convert_currency
      ) do
    with {:ok, convert_tax} <- Ports.FetchConvertionTax.fetch_convertion_tax(final_currency) do
      convertion_tax_with_precision = get_convertion_tax_with_precision(convert_tax)

      converted_value =
        convertion_tax_with_precision
        |> Decimal.mult(Decimal.new(value))
        |> Number.Currency.number_to_currency(format_currency(final_currency))

      {:ok,
       convert_currency
       |> Map.put(:convertion_tax, Decimal.to_float(convertion_tax_with_precision))
       |> Map.put(:converted_value, converted_value)}
    end
  end

  defp get_convertion_tax_with_precision(convert_tax) do
    convert_tax
    |> Decimal.from_float()
    |> Decimal.round(2)
  end

  defp format_currency("BRL"), do: [unit: "R$", separator: ",", format: "%u %n"]
  defp format_currency("USD"), do: [unit: "$", separator: "."]
  defp format_currency("EUR"), do: [unit: "£", separator: "."]
  defp format_currency("JPY"), do: [unit: "¥", separator: ","]
end
