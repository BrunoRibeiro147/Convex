defmodule Core.Repo do
  use Ecto.Repo,
    otp_app: :convex,
    adapter: Ecto.Adapters.SQLite3
end
