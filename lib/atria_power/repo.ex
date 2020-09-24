defmodule AtriaPower.Repo do
  use Ecto.Repo,
    otp_app: :atria_power,
    adapter: Ecto.Adapters.Postgres
end
