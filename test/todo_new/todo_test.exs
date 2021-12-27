defmodule TodoNew.TodoTest do
  use TodoNew.DataCase

  alias TodoNew.Todo

  describe "tasks" do
    alias TodoNew.Todo.Task

    import TodoNew.TodoFixtures
    import TodoNew.AccountsFixtures

    @invalid_attrs %{end_time: nil, user_id: nil, start_time: nil, status: nil, title: nil}

    test "list_tasks/0 returns all tasks" do
      user = user_fixture()
      task = task_fixture(%{user_id: user.id})
      assert Todo.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      user = user_fixture()
      task = task_fixture(%{user_id: user.id})
      assert Todo.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      user = user_fixture()

      valid_attrs = %{
        end_time: ~N[2021-12-22 07:01:00],
        user_id: user.id,
        start_time: ~N[2021-12-22 07:01:00],
        status: 0,
        title: "some title"
      }

      assert {:ok, %Task{} = task} = Todo.create_task(valid_attrs)
      assert task.end_time == ~N[2021-12-22 07:01:00]
      assert task.user_id == user.id
      assert task.start_time == ~N[2021-12-22 07:01:00]
      assert task.status == :New
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todo.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      user = user_fixture()
      task = task_fixture(%{user_id: user.id})

      update_attrs = %{
        end_time: ~N[2021-12-23 07:01:00],
        user_id: user.id,
        start_time: ~N[2021-12-23 07:01:00],
        status: 0,
        title: "some updated title"
      }

      assert {:ok, %Task{} = task} = Todo.update_task(task, update_attrs)
      assert task.end_time == ~N[2021-12-23 07:01:00]
      assert task.user_id == user.id
      assert task.start_time == ~N[2021-12-23 07:01:00]
      assert task.status == :New
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      user = user_fixture()
      task = task_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Todo.update_task(task, @invalid_attrs)
      assert task == Todo.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      user = user_fixture()
      task = task_fixture(%{user_id: user.id})
      assert {:ok, %Task{}} = Todo.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Todo.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      user = user_fixture()
      task = task_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Todo.change_task(task)
    end
  end
end
