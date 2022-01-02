defmodule WebAPI.Swagger.Transactions do
  @moduledoc """
  Swagger Documentation of Transactions 
  """

  defmacro __using__(_opts) do
    quote do
      use PhoenixSwagger

      import Plug.Conn.Status, only: [code: 1]

      def swagger_definitions do
        %{
          TransactionSwagger:
            swagger_schema do
              title("Transaction")
              description("A transaction")

              properties do
                origin_value(:string, "Transaction value to be converted", required: true)

                origin_currency(:string, "Transaction currency base of convertion", required: true)

                final_currency(:string, "Transaction currency final of convertion", required: true)

                convertion_tax(:string, "Transaction convertion tax between currencies",
                  required: true
                )

                user_id(:string, "User who makes the transactin", required: true)
              end

              example(%{
                data: %{
                  origin_value: "£100.00",
                  origin_currency: "EUR",
                  final_currency: "BRL",
                  convertion_tax: 6.34,
                  converted_value: "R$ 634,00",
                  date_hour: "02/01/2022 07:06:05 PM",
                  user_id: "e93554dd-ed4c-4a33-a3e0-154135fedb52"
                },
                id: "3ca9e577-2c0e-46d3-a9f5-a4e41c14dfe9",
                object: "transaction"
              })
            end,
          TransactionsSwagger:
            swagger_schema do
              title("Transaction")
              description("A collection of Transaction")
              type(:array)

              example(%{
                data: [
                  %{
                    origin_value: 1000,
                    origin_currency: "BRL",
                    final_currency: "USD",
                    convertion_tax: 450,
                    user_id: "e93554dd-ed4c-4a33-a3e0-154135fedb52",
                    id: "3ca9e577-2c0e-46d3-a9f5-a4e41c14dfe9",
                    object: "transaction"
                  }
                ],
                object: "list"
              })
            end
        }
      end

      swagger_path :index do
        get("/transactions/{user_id}")
        description("List of transactions")

        parameters do
          user_id(:param, :string, "Transaction User Id", required: true)
        end

        response(code(:ok), "Ok", PhoenixSwagger.Schema.ref(:TransactionsSwagger))
      end

      swagger_path :convert_currency do
        post("/transactions/{user_id}/convert_currency")
        description("Convert currency and create a transaction")

        parameters do
          value(:body, :float, "Value who will be converted", required: true)

          final_currency(:body, :string, "For what currency the value will be converted",
            required: true
          )

          user_id(:param, :string, "User Id who request the convertion", required: true)
        end

        response(code(:ok), "Ok", PhoenixSwagger.Schema.ref(:TransactionSwagger))
      end
    end
  end
end
