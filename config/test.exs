use Mix.Config

# Configure your database
#

config :convex, Core.Repo,
  database: Path.expand(File.cwd!() <> "/database/test/database_test.db"),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :convex, WebAPI.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
