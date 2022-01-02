defmodule WebAPI.Controllers.TransationsTest do
  use WebAPI.ConnCase, async: true
  use Core.DataCase, async: true

  import Hammox
  alias Core.Schemas

  describe "convert_currency/2" do
    setup do
      %{id: user_id} = insert(:user)

      params = %{
        value: 10,
        final_currency: "BRL"
      }

      %{
        params: params,
        user_id: user_id
      }
    end

    test "returns status 200 and the successfull transaction", %{
      conn: conn,
      user_id: user_id,
      params: %{final_currency: final_currency} = params
    } do
      expect(Core.Adapters.FetchConvertionTax.ExchangeRates.Mock, :fetch_convertion_tax, fn _ ->
        {:ok, 6.31}
      end)

      assert %{
               "data" => %{
                 "converted_value" => "R$ 63,10",
                 "convertion_tax" => 6.31,
                 "date_hour" => _date_hour,
                 "final_currency" => ^final_currency,
                 "origin_currency" => "EUR",
                 "origin_value" => "£10.00",
                 "user_id" => ^user_id
               },
               "id" => transaction_id,
               "object" => "transaction"
             } =
               conn
               |> post(Routes.transactions_path(conn, :convert_currency, user_id), params)
               |> json_response(200)

      assert %Schemas.Transaction{} = Core.Repo.get(Schemas.Transaction, transaction_id)
    end

    test "returns status 404 if user was not found", %{conn: conn, params: params} do
      for user_id <- ["some_id", Ecto.UUID.generate()] do
        assert %{
                 "error" => "not_found",
                 "reason" => %{
                   "entity" => "user",
                   "identifier" => ^user_id
                 }
               } =
                 conn
                 |> post(Routes.transactions_path(conn, :convert_currency, user_id), params)
                 |> json_response(404)
      end
    end

    for field <- [:value, :final_currency] do
      test "return status 400 and with changeset error if #{field} is missing", %{
        conn: conn,
        params: params,
        user_id: user_id
      } do
        assert %{
                 "error" => "validation_error",
                 "reason" => [%{"error" => "can't be blank", "path" => [_missing_param]}]
               } =
                 conn
                 |> post(
                   Routes.transactions_path(conn, :convert_currency, user_id),
                   Map.drop(params, [unquote(field)])
                 )
                 |> json_response(400)
      end
    end

    test "return status 400 and an invalid changeset if value is not an number", %{
      conn: conn,
      params: params,
      user_id: user_id
    } do
      assert %{
               "error" => "validation_error",
               "reason" => [%{"error" => "is invalid", "path" => ["value"]}]
             } =
               conn
               |> post(
                 Routes.transactions_path(conn, :convert_currency, user_id),
                 Map.put(params, :value, "blablalba")
               )
               |> json_response(400)
    end

    test "returns status 400 and an invalid changeset if final_currency was not allowed", %{
      conn: conn,
      params: params,
      user_id: user_id
    } do
      assert %{
               "error" => "validation_error",
               "reason" => [
                 %{
                   "error" =>
                     "This currency is not allowed the allowed currencies are: [BRL, USD, EUR, JPY]",
                   "path" => ["final_currency"]
                 }
               ]
             } =
               conn
               |> post(
                 Routes.transactions_path(conn, :convert_currency, user_id),
                 Map.put(params, :final_currency, "blablalba")
               )
               |> json_response(400)
    end

    test "return status 503 case occour an error on fetch external api", %{
      conn: conn,
      params: params,
      user_id: user_id
    } do
      expect(Core.Adapters.FetchConvertionTax.ExchangeRates.Mock, :fetch_convertion_tax, fn _ ->
        {:error, "Occur an error while fetch api, try again"}
      end)

      assert %{"error" => "server_error"} =
               conn
               |> post(
                 Routes.transactions_path(conn, :convert_currency, user_id),
                 params
               )
               |> json_response(503)
    end
  end

  describe "index/2" do
    setup do
      %{id: user_id} = insert(:user)

      insert_list(2, :transaction, user_id: user_id)

      %{user_id: user_id}
    end

    test "returns status 200 and a list of Transactions belongs to the user_id", %{
      conn: conn,
      user_id: user_id
    } do
      assert %{
               "data" => [
                 %{
                   "convertion_tax" => 6.33,
                   "date_hour" => _date_hour_transaction_1,
                   "final_currency" => "BRL",
                   "id" => _id_transaction_1,
                   "object" => "transaction",
                   "origin_currency" => "EUR",
                   "origin_value" => 10.0,
                   "user_id" => ^user_id
                 },
                 %{
                   "convertion_tax" => 6.33,
                   "date_hour" => _date_hour_transaction_2,
                   "final_currency" => "BRL",
                   "id" => _id_transaction_2,
                   "object" => "transaction",
                   "origin_currency" => "EUR",
                   "origin_value" => 10.0,
                   "user_id" => ^user_id
                 }
               ],
               "object" => "list"
             } =
               conn
               |> get(Routes.transactions_path(conn, :index, user_id))
               |> json_response(200)
    end

    test "returns status 404 if user does not exist", %{conn: conn} do
      user_id = Ecto.UUID.generate()

      assert %{
               "error" => "not_found",
               "reason" => %{
                 "entity" => "user",
                 "identifier" => ^user_id
               }
             } =
               conn
               |> get(Routes.transactions_path(conn, :index, user_id))
               |> json_response(404)
    end
  end
end
