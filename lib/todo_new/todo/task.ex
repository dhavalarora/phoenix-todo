defmodule TodoNew.Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias TodoNew.Accounts.User

  schema "tasks" do
    field :end_time, :naive_datetime, default: nil
    field :start_time, :naive_datetime, default: nil

    field :status, Ecto.Enum,
      values: [New: 0, Working: 1, Completed: 2, Deleted: 3],
      default: :New

    field :title
    field :time_taken, :naive_datetime, virtual: true

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :user_id, :status, :start_time, :end_time])
    |> validate_required([:title, :user_id])
  end
end
