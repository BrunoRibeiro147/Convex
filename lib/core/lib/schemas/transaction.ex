defmodule Core.Schemas.Transaction do
  @moduledoc """
  Schema for a Transaction
  """

  use Core.Schema

  @required [
    :origin_value,
    :origin_currency,
    :final_currency,
    :convertion_tax,
    :user_id
  ]
  @optional []

  schema "transactions" do
    field :origin_value, :float
    field :origin_currency, :string
    field :final_currency, :string
    field :convertion_tax, :float

    belongs_to(:user, Core.Schemas.User)

    timestamps()
  end

  @spec changeset(schema :: __MODULE__.t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required ++ @optional)
    |> put_change(:id, Ecto.UUID.generate())
    |> validate_required(@required)
  end
end
