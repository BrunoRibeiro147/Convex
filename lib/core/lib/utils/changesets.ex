defmodule Core.Utils.Changesets do
  @moduledoc """
  Helper module for custom validations and casting external input.
  """

  alias Ecto.Changeset

  @allowed_currencies ["BRL", "USD", "EUR", "JPY"]

  @doc """
  Receives a schema module then casts and validates params using its changeset function.
  """
  @spec cast_and_apply(schema_module :: module(), params :: map()) ::
          {:ok, struct()} | {:error, Changeset.t()}
  def cast_and_apply(schema_module, params) do
    params
    |> schema_module.changeset()
    |> case do
      %{valid?: true} = changeset -> {:ok, Changeset.apply_changes(changeset)}
      changeset -> {:error, changeset}
    end
  end

  @doc """
  Same as cast_and_apply/2, except it raises when changeset is invalid
  """
  @spec cast_and_apply!(schema_module :: module(), params :: map()) ::
          struct() | no_return()
  def cast_and_apply!(schema_module, params) do
    params
    |> schema_module.changeset()
    |> case do
      %{valid?: true} = changeset ->
        Changeset.apply_changes(changeset)

      changeset ->
        raise Ecto.InvalidChangesetError, action: changeset.action, changeset: changeset
    end
  end

  @doc """
  Validates if the currency pass is allowed
  """
  @spec validate_currency(Ecto.Changeset.t(), atom()) :: Ecto.Changeset.t()
  def validate_currency(changeset, field) do
    with {:get_field, currency} when not is_nil(currency) <-
           {:get_field, Changeset.get_field(changeset, field)},
         true <- Enum.member?(@allowed_currencies, currency) do
      changeset
    else
      {:get_field, nil} ->
        changeset

      _ ->
        Changeset.add_error(
          changeset,
          field,
          "This currency is not allowed the allowed currencies are: [" <>
            Enum.join(@allowed_currencies, ", ") <> "]",
          validation: :invalid
        )
    end
  end
end
