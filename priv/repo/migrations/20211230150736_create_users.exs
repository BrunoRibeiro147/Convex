defmodule Core.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table("users", primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string, null: false

      timestamps(type: :utc_datetime_usec)
    end
  end
end
