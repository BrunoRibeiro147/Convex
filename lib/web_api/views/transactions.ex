defmodule WebAPI.Views.Transaction do
  @moduledoc """
  View for User
  """

  use WebAPI, :view

  alias Core.Utils.Format

  def render("item.json", %{
        transaction: transaction
      }),
      do: %{
        id: transaction.id,
        object: "transaction",
        data: render_transaction(transaction)
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
