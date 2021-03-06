defmodule TodoNewWeb.TaskControllerTest do
  use TodoNewWeb.ConnCase

  import TodoNew.TodoFixtures

  @create_attrs %{
    end_time: ~N[2021-12-22 07:01:00],
    start_time: ~N[2021-12-22 07:01:00],
    status: 0,
    title: "some title"
  }
  @update_attrs %{
    end_time: ~N[2021-12-23 07:01:00],
    start_time: ~N[2021-12-23 07:01:00],
    status: 0,
    title: "some updated title"
  }
  @invalid_attrs %{end_time: nil, user_id: nil, start_time: nil, status: nil, title: nil}

  setup %{conn: conn} do
    conn =
      conn
      |> Map.replace!(:secret_key_base, TodoNewWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    register_and_log_in_user(%{conn: conn})
  end

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      conn = get(conn, Routes.task_path(conn, :index))
      assert html_response(conn, 200) =~ "Your Tasks"
    end
  end

  describe "new task" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.task_path(conn, :new))
      assert html_response(conn, 200) =~ "New Task"
    end
  end

  describe "create task" do
    test "redirects to index when data is valid", %{conn: conn} do
      conn = post(conn, Routes.task_path(conn, :create), task: @create_attrs)
      assert redirected_to(conn) == Routes.task_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.task_path(conn, :create), task: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Task"
    end
  end

  describe "show task" do
    setup [:create_task]

    test "redirects when requested by another user", %{conn: conn, task: task} do
      %{conn: conn, user: _new_user} = register_and_log_in_user(%{conn: conn})
      conn = get(conn, Routes.task_path(conn, :show, task))
      assert redirected_to(conn) == Routes.task_path(conn, :index)
    end
  end

  describe "edit task" do
    setup [:create_task]

    test "renders form for editing chosen task", %{conn: conn, task: task} do
      conn = get(conn, Routes.task_path(conn, :edit, task))
      assert html_response(conn, 200) =~ "Edit Task"
    end

    test "redirect when editing with different user", %{conn: conn, task: task} do
      %{conn: conn, user: _new_user} = register_and_log_in_user(%{conn: conn})
      conn = get(conn, Routes.task_path(conn, :edit, task))
      assert redirected_to(conn) == Routes.task_path(conn, :index)
    end
  end

  describe "update task" do
    setup [:create_task]

    test "redirects when data is valid", %{conn: conn, task: task} do
      conn = put(conn, Routes.task_path(conn, :update, task), task: @update_attrs)
      assert redirected_to(conn) == Routes.task_path(conn, :show, task)

      conn = get(conn, Routes.task_path(conn, :show, task))
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, task: task} do
      conn = put(conn, Routes.task_path(conn, :update, task), task: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Task"
    end

    test "redirects when updating with different user", %{conn: conn, task: task} do
      %{conn: conn, user: _new_user} = register_and_log_in_user(%{conn: conn})
      conn = put(conn, Routes.task_path(conn, :update, task), task: @update_attrs)
      assert redirected_to(conn) == Routes.task_path(conn, :index)
    end
  end

  describe "delete task" do
    setup [:create_task]

    test "deletes chosen task", %{conn: conn, task: task} do
      conn = delete(conn, Routes.task_path(conn, :delete, task))
      assert redirected_to(conn) == Routes.task_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.task_path(conn, :show, task))
      end
    end

    test "redirects when deleting with different user", %{conn: conn, task: task} do
      %{conn: conn, user: _new_user} = register_and_log_in_user(%{conn: conn})
      conn = delete(conn, Routes.task_path(conn, :delete, task))
      assert redirected_to(conn) == Routes.task_path(conn, :index)
    end
  end

  describe "update status" do
    setup [:create_task]

    test "updates status from New -> Working -> Completed", %{conn: conn, task: task} do
      assert task.status == :New
      conn = patch(conn, Routes.task_path(conn, :update_status, task.id), new_status: "Working")
      conn = get(conn, Routes.task_path(conn, :show, task))
      assert html_response(conn, 200) =~ "Working"

      conn = patch(conn, Routes.task_path(conn, :update_status, task.id), new_status: "Completed")
      conn = get(conn, Routes.task_path(conn, :show, task))
      assert html_response(conn, 200) =~ "Completed"
    end

    test "no update when new status is not acc. to flow New -> Working -> Completed", %{
      conn: conn,
      task: task
    } do
      assert task.status == :New
      conn = patch(conn, Routes.task_path(conn, :update_status, task.id), new_status: "Completed")
      conn = get(conn, Routes.task_path(conn, :show, task))
      assert html_response(conn, 200) =~ "New"

      conn = patch(conn, Routes.task_path(conn, :update_status, task.id), new_status: "Working")
      conn = get(conn, Routes.task_path(conn, :show, task))
      assert html_response(conn, 200) =~ "Working"

      conn = patch(conn, Routes.task_path(conn, :update_status, task.id), new_status: "New")
      conn = get(conn, Routes.task_path(conn, :show, task))
      assert html_response(conn, 200) =~ "Working"

      conn = patch(conn, Routes.task_path(conn, :update_status, task.id), new_status: "Completed")
      conn = get(conn, Routes.task_path(conn, :show, task))
      assert html_response(conn, 200) =~ "Completed"

      conn = patch(conn, Routes.task_path(conn, :update_status, task.id), new_status: "New")
      conn = get(conn, Routes.task_path(conn, :show, task))
      assert html_response(conn, 200) =~ "Completed"
    end

    test "redirects when updating with different user", %{conn: conn, task: task} do
      %{conn: conn, user: _new_user} = register_and_log_in_user(%{conn: conn})
      conn = patch(conn, Routes.task_path(conn, :update_status, task.id), new_status: "Working")
      assert redirected_to(conn) == Routes.task_path(conn, :index)
    end
  end

  describe "clear completed tasks" do
    setup [:create_task]

    test "Mark completed tasks as deleted", %{conn: conn, task: task, user: user} do
      assert task.status == :New
      conn = patch(conn, Routes.task_path(conn, :update_status, task.id, new_status: "Working"))
      conn = patch(conn, Routes.task_path(conn, :update_status, task.id), new_status: "Completed")
      conn = get(conn, Routes.task_path(conn, :show, task))
      assert html_response(conn, 200) =~ "Completed"

      task2 = task_fixture(%{user_id: user.id})
      assert task2.status == :New
      conn = patch(conn, Routes.task_path(conn, :update_status, task2.id, new_status: "Working"))

      conn =
        patch(conn, Routes.task_path(conn, :update_status, task2.id), new_status: "Completed")

      conn = get(conn, Routes.task_path(conn, :show, task2))
      assert html_response(conn, 200) =~ "Completed"

      conn = get(conn, Routes.task_path(conn, :clear_completed))
      conn = get(conn, Routes.task_path(conn, :show, task))
      assert html_response(conn, 200) =~ "Deleted"
      conn = get(conn, Routes.task_path(conn, :show, task2))
      assert html_response(conn, 200) =~ "Deleted"
    end
  end

  defp create_task(%{conn: _conn, user: user}) do
    task = task_fixture(%{user_id: user.id})
    %{task: task}
  end
end
