defmodule Core.Factories.Transaction do
  @moduledoc false

  use ExMachina.Ecto, repo: Core.Repo

  alias Core.Schemas.Transaction

  defmacro __using__(_opts) do
    quote do
      def transaction_factory do
        %Transaction{
          id: Ecto.UUID.generate(),
          user_id: Ecto.UUID.generate(),
          origin_value: 10.0,
          origin_currency: "EUR",
          final_currency: "BRL",
          convertion_tax: 6.33
        }
      end
    end
  end
end
