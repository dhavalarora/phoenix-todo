defmodule TodoNew.Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :end_time, :naive_datetime
    field :person_id, :integer
    field :start_time, :naive_datetime
    field :status, :integer
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :person_id, :status, :start_time, :end_time])
    |> validate_required([:title, :person_id, :status, :start_time, :end_time])
  end
end
