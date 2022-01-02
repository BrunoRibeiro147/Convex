defmodule WebAPI.Views.Transaction do
  @moduledoc """
  View for User
  """

  use WebAPI, :view

  alias Core.Schemas
  alias Core.Utils.Format

  def render("item.json", %{
        transaction: transaction
      }),
      do: %{
        id: transaction.id,
        object: "transaction",
        data: render_transaction(transaction)
      }

  def render("collection.json", %{
        entries: entries
      }),
      do: %{
        object: "list",
        data: render_many(entries, __MODULE__, "transaction.json", as: :transaction)
      }

  def render("transaction.json", %{
        transaction: %Schemas.Transaction{} = transaction
      }) do
    transaction
    |> render_transaction()
    |> Map.merge(%{
      id: transaction.id,
      object: "transaction"
    })
  end

  defp render_transaction(%Schemas.Transaction{} = transaction),
    do: %{
      convertion_tax: transaction.convertion_tax,
      final_currency: transaction.final_currency,
      origin_currency: transaction.origin_currency,
      origin_value: transaction.origin_value,
      user_id: transaction.user_id,
      date_hour: transaction.inserted_at
    }

  defp render_transaction(transaction),
    do: %{
      convertion_tax: transaction.convertion_tax,
      final_currency: transaction.final_currency,
      origin_currency: transaction.origin_currency,
      origin_value: transaction.origin_value,
      converted_value: transaction.converted_value,
      user_id: transaction.user_id,
      date_hour: Format.format_datetime_to_brazilian(transaction.inserted_at)
    }
end
