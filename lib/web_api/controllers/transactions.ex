defmodule WebAPI.Controllers.Transactions do
  @moduledoc """
  Controller for Transactions
  """

  use WebAPI, :controller

  alias Core.CurrencyConvertor
  alias Core.Schemas
  alias Core.Transaction
  alias Core.User
  alias Core.Utils
  alias WebAPI.Helpers.ErrorResponses

  def convert_currency(conn, %{"user_id" => user_id} = params) do
    with {:ok, %Schemas.User{}} <- User.Services.GetUser.execute(user_id),
         {:ok,
          %CurrencyConvertor.Commands.ConvertCurrency{converted_value: converted_value} =
            convert_currency_service} <-
           call_command_service_convert_currency(params),
         %Schemas.Transaction{} = transaction <-
           call_command_service_create_transaction(convert_currency_service, user_id) do
      render_transaction(conn, build_transaction_params(transaction, converted_value))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        ErrorResponses.changeset_error(conn, changeset, 400)

      {:error, :not_found} ->
        ErrorResponses.not_found(conn, "user", user_id)

      {:error, _} ->
        ErrorResponses.server_error(conn, 503)
    end
  end

  defp call_command_service_convert_currency(params) do
    with {:ok, %CurrencyConvertor.Commands.ConvertCurrency{} = convert_currency_command} <-
           Utils.Changesets.cast_and_apply(CurrencyConvertor.Commands.ConvertCurrency, params) do
      CurrencyConvertor.Services.ConvertCurrency.execute(convert_currency_command)
    end
  end

  defp call_command_service_create_transaction(params, user_id) do
    with {:ok, %Transaction.Commands.CreateTransaction{} = create_transaction_command} <-
           Utils.Changesets.cast_and_apply(
             Transaction.Commands.CreateTransaction,
             params
             |> Map.put(:user_id, user_id)
             |> Map.from_struct()
           ) do
      Transaction.Services.CreateTransaction.execute(create_transaction_command)
    end
  end

  defp build_transaction_params(transaction, converted_value) do
    transaction
    |> Map.from_struct()
    |> Map.put(:converted_value, converted_value)
    |> Map.put(
      :origin_value,
      transaction.origin_value
      |> Utils.Format.format_value_with_precision(2)
      |> Number.Currency.number_to_currency(
        Utils.Format.format_currency(transaction.origin_currency)
      )
    )
  end

  defp render_transaction(conn, transaction) do
    conn
    |> put_view(WebAPI.Views.Transaction)
    |> render("item.json", %{
      transaction: transaction
    })
  end
end
