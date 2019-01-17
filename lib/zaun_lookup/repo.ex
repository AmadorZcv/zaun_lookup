defmodule ZaunLookup.Repo do
  use Ecto.Repo,
    otp_app: :zaun_lookup,
    adapter: Ecto.Adapters.Postgres
end
