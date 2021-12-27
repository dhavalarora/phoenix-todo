defmodule TodoNewWeb.TaskControllerTest do
  use TodoNewWeb.ConnCase

  import TodoNew.TodoFixtures
  import TodoNew.AccountsFixtures
  alias TodoNew.Accounts

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

    %{user: user_fixture(), conn: conn}
  end

  describe "index" do
    test "lists all tasks", %{conn: conn, user: user} do
      token = Accounts.generate_user_session_token(user)
      conn = put_session(conn, :user_token, token)

      conn = get(conn, Routes.task_path(conn, :index))
      assert html_response(conn, 200) =~ "Your Tasks"
    end
  end

  describe "new task" do
    test "renders form", %{conn: conn, user: user} do
      token = Accounts.generate_user_session_token(user)
      conn = put_session(conn, :user_token, token)

      conn = get(conn, Routes.task_path(conn, :new))
      assert html_response(conn, 200) =~ "New Task"
    end
  end

  describe "create task" do
    test "redirects to index when data is valid", %{conn: conn, user: user} do
      token = Accounts.generate_user_session_token(user)
      conn = put_session(conn, :user_token, token)

      conn = post(conn, Routes.task_path(conn, :create), task: @create_attrs)
      assert redirected_to(conn) == Routes.task_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      token = Accounts.generate_user_session_token(user)
      conn = put_session(conn, :user_token, token)
      conn = post(conn, Routes.task_path(conn, :create), task: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Task"
    end
  end

  describe "edit task" do
    setup [:create_task]

    test "renders form for editing chosen task", %{conn: conn, task: task, user: user} do
      token = Accounts.generate_user_session_token(user)
      conn = put_session(conn, :user_token, token)
      conn = get(conn, Routes.task_path(conn, :edit, task))
      assert html_response(conn, 200) =~ "Edit Task"
    end

    test "redirect when editing with different user", %{conn: conn, task: task} do
      new_user = user_fixture()

      token = Accounts.generate_user_session_token(new_user)
      conn = put_session(conn, :user_token, token)

      conn = get(conn, Routes.task_path(conn, :edit, task))
      assert redirected_to(conn) == Routes.task_path(conn, :index)
    end
  end

  describe "update task" do
    setup [:create_task]

    test "redirects when data is valid", %{conn: conn, task: task, user: user} do
      token = Accounts.generate_user_session_token(user)
      conn = put_session(conn, :user_token, token)

      conn = put(conn, Routes.task_path(conn, :update, task), task: @update_attrs)
      assert redirected_to(conn) == Routes.task_path(conn, :show, task)

      conn = get(conn, Routes.task_path(conn, :show, task))
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, task: task, user: user} do
      token = Accounts.generate_user_session_token(user)
      conn = put_session(conn, :user_token, token)
      conn = put(conn, Routes.task_path(conn, :update, task), task: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Task"
    end

    test "redirects when updating with different user", %{conn: conn, task: task} do
      new_user = user_fixture()

      token = Accounts.generate_user_session_token(new_user)
      conn = put_session(conn, :user_token, token)

      conn = put(conn, Routes.task_path(conn, :update, task), task: @update_attrs)
      assert redirected_to(conn) == Routes.task_path(conn, :index)
    end
  end

  describe "delete task" do
    setup [:create_task]

    test "deletes chosen task", %{conn: conn, task: task, user: user} do
      token = Accounts.generate_user_session_token(user)
      conn = put_session(conn, :user_token, token)
      conn = delete(conn, Routes.task_path(conn, :delete, task))
      assert redirected_to(conn) == Routes.task_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.task_path(conn, :show, task))
      end
    end

    test "redirects when deleting with different user", %{conn: conn, task: task} do
      new_user = user_fixture()

      token = Accounts.generate_user_session_token(new_user)
      conn = put_session(conn, :user_token, token)

      conn = delete(conn, Routes.task_path(conn, :delete, task))
      assert redirected_to(conn) == Routes.task_path(conn, :index)
    end
  end

  describe "update status" do
    setup [:create_task]

    test "updates status from New -> Working -> Completed", %{conn: conn, task: task, user: user} do
      token = Accounts.generate_user_session_token(user)
      conn = put_session(conn, :user_token, token)
      assert task.status == :New

      conn = patch(conn, Routes.task_path(conn, :update_status, task.id))
      conn = get(conn, Routes.task_path(conn, :show, task))
      assert html_response(conn, 200) =~ "Working"

      conn = patch(conn, Routes.task_path(conn, :update_status, task.id))
      conn = get(conn, Routes.task_path(conn, :show, task))
      assert html_response(conn, 200) =~ "Completed"
    end

    test "renders errors when data is invalid", %{conn: conn, task: task, user: user} do
      token = Accounts.generate_user_session_token(user)
      conn = put_session(conn, :user_token, token)
      conn = put(conn, Routes.task_path(conn, :update, task), task: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Task"
    end

    # test "redirects when updating with different user", %{conn: conn, task: task} do
    #   new_user = user_fixture()

    #   token = Accounts.generate_user_session_token(new_user)
    #   conn = put_session(conn, :user_token, token)

    #   conn = put(conn, Routes.task_path(conn, :update, task), task: @update_attrs)
    #   assert redirected_to(conn) == Routes.task_path(conn, :index)
    # end
  end

  defp create_task(_) do
    user = user_fixture()
    task = task_fixture(%{user_id: user.id})
    %{user: user, task: task}
  end
end
