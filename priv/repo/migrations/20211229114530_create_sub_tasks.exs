defmodule TodoNew.Repo.Migrations.CreateSubTasks do
  use Ecto.Migration

  def change do
    create table(:sub_tasks) do
      add :title, :string
      add :task_id, references(:tasks, on_delete: :delete_all), null: false
      add :status, :integer
      add :start_time, :naive_datetime
      add :end_time, :naive_datetime

      timestamps()
    end

    create index(:sub_tasks, [:task_id])
  end
end
