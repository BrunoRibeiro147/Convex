defmodule Core.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table("transactions", primary_key: false) do
      add :id, :string, primary_key: true
      add :origin_value, :integer
      add :origin_currency, :string
      add :final_currency, :string
      add :convertion_tax, :integer
      add :user_id, references("users", type: :string)

      timestamps(type: :utc_datetime_usec)
    end
  end
end
