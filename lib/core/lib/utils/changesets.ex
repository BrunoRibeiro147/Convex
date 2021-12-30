defmodule Core.Utils.Changesets do
  @moduledoc """
  Helper module for custom validations and casting external input.
  """

  alias Ecto.Changeset

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
end
