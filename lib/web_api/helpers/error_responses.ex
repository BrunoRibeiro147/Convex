defmodule WebAPI.Helpers.ErrorResponses do
  @moduledoc """
  Module that centralizes error responses from controllers
  """

  import Plug.Conn

  @typedoc """
  What is possible to parse as JSON.
  """
  @type json :: String.t() | number() | list(json()) | %{required(String.t() | atom()) => json}

  @doc """
  Generates an error response with HTTP response code `status`.
  The response is based on errors from Ecto.Changeset `changeset`
  """
  @spec changeset_error(Plug.Conn.t(), Ecto.Changeset.t(), status :: non_neg_integer()) ::
          Plug.Conn.t()
  def changeset_error(conn, changeset, status) do
    errors = parse_changeset_errors(changeset)

    json_resp(conn, status, %{error: "validation_error", reason: errors})
  end

  @doc """
  Returns an 404 HTTP response with `entity` and `identifier` in the response body
  """
  @spec not_found(Plug.Conn.t(), String.t(), String.t()) :: Plug.Conn.t()
  def not_found(conn, entity, identifier) do
    json_resp(conn, 404, %{error: "not_found", reason: %{entity: entity, identifier: identifier}})
  end

  @doc """
  Returns a 403 HTTP response
  """
  @spec unauthorized(Plug.Conn.t()) :: Plug.Conn.t()
  def unauthorized(conn) do
    json_resp(conn, 403, %{error: "unauthorized"})
  end

  @doc """
  Returns a generic server error with HTTP response code `status`
  """
  @spec server_error(Plug.Conn.t(), status :: non_neg_integer()) :: Plug.Conn.t()
  def server_error(conn, status, message \\ "server_error") do
    json_resp(conn, status, %{error: message})
  end

  defp parse_changeset_errors(changeset, existing_path \\ [])

  defp parse_changeset_errors(%Ecto.Changeset{valid?: true}, _base_path), do: []

  defp parse_changeset_errors(
         %Ecto.Changeset{errors: errors, changes: changes},
         base_path
       ) do
    base_errors = format_errors(errors, base_path)

    changes
    |> Enum.reduce(base_errors, fn item, acc ->
      format_change_errors(item, base_path, acc)
    end)
    |> Enum.reverse()
    |> Enum.reject(&Enum.empty?/1)
    |> List.flatten()
  end

  defp format_errors(errors, base_path) do
    Enum.map(errors, fn
      {key, {error, _opts}} ->
        %{"path" => base_path ++ [to_string(key)], "error" => error}
    end)
  end

  defp format_change_errors({field, [%Ecto.Changeset{} | _] = changeset_list}, base_path, acc) do
    current =
      changeset_list
      |> Enum.with_index()
      |> Enum.reduce([], fn {changeset, idx}, list_errors ->
        [parse_changeset_errors(changeset, base_path ++ [field, idx]) | list_errors]
      end)

    current ++ acc
  end

  defp format_change_errors({field, %Ecto.Changeset{} = changeset}, base_path, acc) do
    current =
      parse_changeset_errors(
        changeset,
        base_path ++ [to_string(field)]
      )

    current ++ acc
  end

  defp format_change_errors(_, _base_path, acc), do: acc

  @spec json_resp(Plug.Conn.t(), integer(), json()) :: Plug.Conn.t()
  defp json_resp(conn, status, val) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(val))
  end
end
