defmodule Core.Transaction.Commands.CreateTransaction do
  @moduledoc """
  Command to create a Transaction
  """

  use Core.EmbeddedSchema
  alias Core.Utils

  @required [
    :value,
    :origin_currency,
    :final_currency,
    :convertion_tax,
    :user_id
  ]
  @optional []

  embedded_schema do
    field :origin_currency, :string
    field :final_currency, :string
    field :convertion_tax, :integer
    field :value, :integer
    field :user_id, Ecto.UUID
  end

  @spec changeset(schema :: __MODULE__.t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> Utils.Changesets.validate_currency(:origin_currency)
    |> Utils.Changesets.validate_currency(:final_currency)
  end
end
