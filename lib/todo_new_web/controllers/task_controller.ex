defmodule TodoNewWeb.TaskController do
  use TodoNewWeb, :controller

  alias TodoNew.Todo
  alias TodoNew.Todo.Task
  alias TodoNew.Todo.SubTask

  def index(conn, params) do
    user = conn.assigns[:current_user]
    tasks = Todo.list_user_tasks(user)
    render(conn, "index.html", tasks: tasks, filter: Map.get(params, "filter", "all"))
  end

  def new(conn, _params) do
    changeset = Todo.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    user = conn.assigns[:current_user]

    case Todo.create_user_task(task_params, user) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.task_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Todo.get_task!(id)

    conn
    |> authorize_task(task)
    |> render("show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = Todo.get_task!(id)
    conn = authorize_task(conn, task)
    changeset = Todo.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Todo.get_task!(id)
    conn = authorize_task(conn, task)

    case Todo.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Todo.get_task!(id)
    conn = authorize_task(conn, task)
    {:ok, _task} = Todo.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.task_path(conn, :index))
  end

  def update_status(conn, %{"id" => id, "new_status" => new_status}) do
    task = Todo.get_task!(id)
    conn = authorize_task(conn, task)

    task_params =
      case task.status do
        :New ->
          if new_status == "Working" do
            %{status: "Working", start_time: Timex.now("Asia/Kolkata")}
          else
            %{}
          end

        :Working ->
          if new_status == "Completed" do
            %{status: "Completed", end_time: Timex.now("Asia/Kolkata")}
          else
            %{}
          end

        _ ->
          %{}
      end

    {:ok, _task} = Todo.update_task(task, task_params)

    conn
    |> put_flash(:info, "Task updated successfully.")
    |> redirect(to: Routes.task_path(conn, :index))
  end

  def clear_completed(conn, _params) do
    user = conn.assigns[:current_user]
    Todo.clear_completed(user.id)
    index(conn, %{filter: "all"})
  end

  ########################################### Subtask functions ###########################################

  def subtasks(conn, %{"id" => task_id}) do
    task = Todo.get_task!(task_id)
    conn = authorize_task(conn, task)
    subtasks = Todo.list_subtasks(task_id)
    render(conn, "subtask.html", task_id: task_id, sub_tasks: subtasks)
  end

  def new_subtask(conn, %{"id" => task_id}) do
    task = Todo.get_task!(task_id)
    conn = authorize_task(conn, task)
    changeset = Todo.change_subtask(%SubTask{})
    render(conn, "newsubtask.html", task_id: task_id, changeset: changeset)
  end

  def create_subtask(conn, %{"id" => task_id, "sub_task" => subtask_params}) do
    task = Todo.get_task!(task_id)
    conn = authorize_task(conn, task)
    subtask_params = Map.put(subtask_params, "task_id", task_id)

    case Todo.create_subtask(subtask_params) do
      {:ok, _subtask} ->
        conn
        |> put_flash(:info, "SubTask created successfully.")
        |> redirect(to: Routes.sub_task_path(conn, :subtasks, task_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "newsubtask.html", task_id: task_id, changeset: changeset)
    end
  end

  def edit_subtask(conn, %{"id" => task_id, "subtask_id" => subtask_id}) do
    task = Todo.get_task!(task_id)
    subtask = Todo.get_subtask!(subtask_id)

    conn =
      conn
      |> authorize_task(task)
      |> authorize_subtask(task, subtask)

    changeset = Todo.change_subtask(subtask)
    render(conn, "editsubtask.html", task: task, subtask: subtask, changeset: changeset)
  end

  def update_subtask(conn, %{
        "id" => task_id,
        "subtask_id" => subtask_id,
        "sub_task" => subtask_params
      }) do
    task = Todo.get_task!(task_id)
    subtask = Todo.get_subtask!(subtask_id)

    conn
    |> authorize_task(task)
    |> authorize_subtask(task, subtask)

    case Todo.update_subtask(subtask, subtask_params) do
      {:ok, subtask} ->
        conn
        |> put_flash(:info, "SubTask updated successfully.")
        |> redirect(to: Routes.sub_task_path(conn, :show_subtask, task.id, subtask.id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "editsubtask.html", task: task, subtask: subtask, changeset: changeset)
    end
  end

  def show_subtask(conn, %{"id" => task_id, "subtask_id" => subtask_id}) do
    task = Todo.get_task!(task_id)
    subtask = Todo.get_subtask!(subtask_id)

    conn
    |> authorize_task(task)
    |> authorize_subtask(task, subtask)
    |> render("showsubtask.html", task: task, subtask: subtask)
  end

  def delete_subtask(conn, %{"id" => task_id, "subtask_id" => subtask_id}) do
    task = Todo.get_task!(task_id)
    subtask = Todo.get_subtask!(subtask_id)
    conn =
      conn
      |> authorize_task(task)
      |> authorize_subtask(task, subtask)
    {:ok, _subtask} = Todo.delete_subtask(subtask)
    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.sub_task_path(conn, :subtasks, task_id))
  end

  def update_subtask_status(conn, %{"id" => task_id, "subtask_id" => subtask_id, "new_status" => new_status}) do
    task = Todo.get_task!(task_id)
    subtask = Todo.get_subtask!(subtask_id)
    conn =
      conn
      |> authorize_task(task)
      |> authorize_subtask(task, subtask)

    subtask_params =
      case subtask.status do
        :New ->
          if new_status == "Working" do
            %{status: "Working", start_time: Timex.now("Asia/Kolkata")}
          else
            %{}
          end

        :Working ->
          if new_status == "Completed" do
            %{status: "Completed", end_time: Timex.now("Asia/Kolkata")}
          else
            %{}
          end

        _ ->
          %{}
      end

    {:ok, _task} = Todo.update_subtask(subtask, subtask_params)

    conn
    |> put_flash(:info, "SubTask updated successfully.")
    |> redirect(to: Routes.sub_task_path(conn, :subtasks, task_id))
  end
  def authorize_task(conn, task) do
    if task.user_id == conn.assigns[:current_user].id do
      conn
    else
      conn
      |> put_flash(:error, "Access denied")
      |> redirect(to: Routes.task_path(conn, :index))
      |> halt()
    end
  end

  def authorize_subtask(conn, task, subtask) do
    if task.id == subtask.task_id do
      conn
    else
      conn
      |> put_flash(:error, "Access denied")
      |> redirect(to: Routes.task_path(conn, :index))
      |> halt()
    end
  end
end
