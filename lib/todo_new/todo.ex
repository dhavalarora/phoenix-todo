defmodule TodoNew.Todo do
  @moduledoc """
  The Todo context.
  """

  import Ecto.Query, warn: false
  alias TodoNew.Repo

  alias TodoNew.Todo.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Task |> Repo.get!(id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  @doc """
  Returns the list of user's non-deleted tasks ordered by status
  """
  def list_user_tasks(user) do
    Repo.all(
      from t in Task, where: t.user_id == ^user.id and t.status != :Deleted, order_by: t.status
    )
  end

  @doc """
  Creates a task belonging to the user.

  ## Examples

      iex> create_user_task(%{field: value}, user)
      {:ok, %Task{}}

      iex> create_user_task(%{field: bad_value}, user)
      {:error, %Ecto.Changeset{}}

  """
  def create_user_task(attrs, user) do
    attrs = Map.put(attrs, "user_id", user.id)

    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single task with user preloaded.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task_and_user!(id), do: Task |> Repo.get!(id) |> Repo.preload(:user)

  def clear_completed(user_id) do
    query = from(i in Task, where: i.user_id == ^user_id, where: i.status == :Completed)
    Repo.update_all(query, set: [status: :Deleted])
  end
end
