defmodule Core.CurrencyConvertor.Commands.ConvertCurrency do
  @moduledoc """
  Command to convert currency
  """

  use Core.EmbeddedSchema
  alias Core.Utils

  @required [
    :value,
    :final_currency
  ]
  @optional []

  embedded_schema do
    field :final_currency, :string
    field :value, :integer
    field :convertion_tax, :float
    field :converted_value, :string
  end

  @spec changeset(schema :: __MODULE__.t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> Utils.Changesets.validate_currency(:final_currency)
  end
end
