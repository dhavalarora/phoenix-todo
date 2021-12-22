defmodule TodoNew.Repo do
  use Ecto.Repo,
    otp_app: :todo_new,
    adapter: Ecto.Adapters.Postgres
end
