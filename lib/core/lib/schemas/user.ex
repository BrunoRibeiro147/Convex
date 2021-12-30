defmodule Core.Schemas.User do
  @moduledoc """
  Schema for a User
  """

  use Core.Schema

  @required [:name]
  @optional []

  schema "users" do
    field :name, :string

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
