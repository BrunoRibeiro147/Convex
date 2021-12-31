defmodule Core.Utils.Format do
  @moduledoc """
  Helper module for format data inputs
  """

  @doc """
  Receives a value and returns a float with the precision passed
  """
  @spec format_value_with_precision(value :: integer() | float(), precision :: integer()) ::
          Decimal.t()
  def format_value_with_precision(value, precision) do
    value
    |> Decimal.from_float()
    |> Decimal.round(precision)
  end

  @doc """
  Receives a datetime and returns an string with brazilian date format
  """

  @spec format_datetime_to_brazilian(datetime :: DateTime.t()) :: String.t()
  def format_datetime_to_brazilian(datetime) do
    Calendar.strftime(datetime, "%d/%m/%Y %I:%M:%S %p")
  end

  @doc """
  Receives a currency and returns the formattion of it
  """
  @spec format_currency(currency :: String.t()) :: Keyword.t()
  def format_currency("BRL"), do: [unit: "R$", separator: ",", format: "%u %n"]
  def format_currency("USD"), do: [unit: "$", separator: "."]
  def format_currency("EUR"), do: [unit: "£", separator: "."]
  def format_currency("JPY"), do: [unit: "¥", separator: ","]
  def format_currency(_), do: [unit: "", separator: "."]
end
