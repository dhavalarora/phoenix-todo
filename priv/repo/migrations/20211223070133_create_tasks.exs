defmodule TodoNew.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :status, :integer
      add :start_time, :naive_datetime
      add :end_time, :naive_datetime

      timestamps()
    end

    create index(:tasks, [:user_id])
  end
end
