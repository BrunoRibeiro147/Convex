defmodule Core.Ports.FetchConvertionTax do
  @moduledoc """
  Interface for interacting with FetchConvertionTax providers
  """

  @adapter Application.compile_env!(:convex, [__MODULE__, :adapter])

  @callback fetch_convertion_tax(currency :: String.t()) ::
              {:ok, convertion_tax :: float()} | {:error, reason :: term()}

  @doc """
  Fetch the latest convertion tax for the pass currency
  """
  @spec fetch_convertion_tax(currency :: String.t()) ::
          {:ok, convertion_tax :: float()} | {:error, reason :: term()}
  defdelegate fetch_convertion_tax(currency), to: @adapter
end
