defmodule TodoNew.Todo.SubTask do
  use Ecto.Schema
  import Ecto.Changeset
  alias TodoNew.Todo.Task

  schema "sub_tasks" do
    field :end_time, :naive_datetime, default: nil
    field :start_time, :naive_datetime, default: nil

    field :status, Ecto.Enum,
      values: [New: 0, Working: 1, Completed: 2, Deleted: 3],
      default: :New

    field :title
    field :time_taken, :naive_datetime, virtual: true

    belongs_to :task, Task

    timestamps()
  end

  @doc false
  def changeset(sub_task, attrs) do
    sub_task
    |> cast(attrs, [:title, :task_id, :status, :start_time, :end_time])
    |> validate_required([:title, :task_id])
  end
end
