defmodule Core.Adapters.FetchConvertionTax.ExchangeRates do
  @moduledoc """
  Adapter for ExchangeRates implements FetchConvertionTax
  """

  @behaviour Core.Ports.FetchConvertionTax

  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://api.exchangeratesapi.io/v1/"
  plug Tesla.Middleware.JSON

  @impl true
  def fetch_convertion_tax(currency) do
    case fetch_api(currency) do
      {:ok, %Tesla.Env{status: 200, body: %{"rates" => result}}} ->
        {:ok, Map.get(result, currency)}

      _ ->
        {:error, "Occur an error while fetch api, try again"}
    end
  end

  defp fetch_api(currency) do
    get("/latest",
      query: [
        access_key: "8ed10c4b00be449829dce3d4daeda009",
        symbols: currency,
        format: 1
      ]
    )
  end
end
