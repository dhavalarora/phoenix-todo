defmodule TodoNew.TodoFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoNew.Todo` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        end_time: ~N[2021-12-22 07:01:00],
        start_time: ~N[2021-12-22 07:01:00],
        status: 0,
        title: "some title"
      })
      |> TodoNew.Todo.create_task()

    task
  end
end
