defmodule TodoNew.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :person_id, :integer
      add :status, :integer
      add :start_time, :naive_datetime
      add :end_time, :naive_datetime

      timestamps()
    end
  end
end
