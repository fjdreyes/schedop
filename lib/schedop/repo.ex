defmodule Schedop.Repo do
  use Ecto.Repo,
    otp_app: :schedop,
    adapter: Ecto.Adapters.Postgres
end
