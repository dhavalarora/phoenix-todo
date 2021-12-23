defmodule TodoNew.TodoTest do
  use TodoNew.DataCase

  alias TodoNew.Todo

  describe "tasks" do
    alias TodoNew.Todo.Task

    import TodoNew.TodoFixtures

    @invalid_attrs %{end_time: nil, person_id: nil, start_time: nil, status: nil, title: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Todo.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Todo.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{end_time: ~N[2021-12-22 07:01:00], person_id: 42, start_time: ~N[2021-12-22 07:01:00], status: 42, title: "some title"}

      assert {:ok, %Task{} = task} = Todo.create_task(valid_attrs)
      assert task.end_time == ~N[2021-12-22 07:01:00]
      assert task.person_id == 42
      assert task.start_time == ~N[2021-12-22 07:01:00]
      assert task.status == 42
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todo.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{end_time: ~N[2021-12-23 07:01:00], person_id: 43, start_time: ~N[2021-12-23 07:01:00], status: 43, title: "some updated title"}

      assert {:ok, %Task{} = task} = Todo.update_task(task, update_attrs)
      assert task.end_time == ~N[2021-12-23 07:01:00]
      assert task.person_id == 43
      assert task.start_time == ~N[2021-12-23 07:01:00]
      assert task.status == 43
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Todo.update_task(task, @invalid_attrs)
      assert task == Todo.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Todo.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Todo.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Todo.change_task(task)
    end
  end
end
