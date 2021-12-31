defmodule Core.User.Services.GetUserTest do
  use Core.DataCase

  alias Core.Schemas
  alias Core.User.Services

  describe "execute/1" do
    setup do
      %{id: user_id} = insert(:user)

      %{user_id: user_id}
    end

    test "returns an user if was successfully fetched", %{user_id: user_id} do
      assert {:ok, %Schemas.User{}} = Services.GetUser.execute(user_id)
    end

    test "returns an error if couldn't cast parameter as UUID" do
      assert {:error, :not_found} = Services.GetUser.execute("banana")
    end

    test "returns an error if user was not found" do
      assert {:error, :not_found} = Services.GetUser.execute(Ecto.UUID.generate())
    end
  end
end
