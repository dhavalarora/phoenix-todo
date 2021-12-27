defmodule TodoNewWeb.TaskController do
  use TodoNewWeb, :controller

  alias TodoNew.Todo
  alias TodoNew.Todo.Task

  def index(conn, _params) do
    user = conn.assigns[:current_user]
    tasks = Todo.list_user_tasks(user)
    render(conn, "index.html", tasks: tasks)
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
    user = conn.assigns[:current_user]
    task = Todo.get_task_and_user!(id)

    if task.user.id == user.id do
      render(conn, "show.html", task: task)
    else
      conn
      |> put_flash(:error, "Access denied")
      |> redirect(to: Routes.task_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    user = conn.assigns[:current_user]
    task = Todo.get_task_and_user!(id)

    if task.user.id == user.id do
      changeset = Todo.change_task(task)
      render(conn, "edit.html", task: task, changeset: changeset)
    else
      conn
      |> put_flash(:error, "Access denied")
      |> redirect(to: Routes.task_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    user = conn.assigns[:current_user]
    task = Todo.get_task_and_user!(id)

    if task.user.id == user.id do
      case Todo.update_task(task, task_params) do
        {:ok, task} ->
          conn
          |> put_flash(:info, "Task updated successfully.")
          |> redirect(to: Routes.task_path(conn, :show, task))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", task: task, changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, "Access denied")
      |> redirect(to: Routes.task_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns[:current_user]
    task = Todo.get_task_and_user!(id)

    if task.user.id == user.id do
      {:ok, _task} = Todo.delete_task(task)

      conn
      |> put_flash(:info, "Task deleted successfully.")
      |> redirect(to: Routes.task_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Access denied")
      |> redirect(to: Routes.task_path(conn, :index))
    end
  end

  def update_status(conn, %{"id" => id}) do
    user = conn.assigns[:current_user]
    task = Todo.get_task_and_user!(id)

    task_params =
      case task.status do
        :New ->
          %{status: "Working", start_time: Timex.now("Asia/Kolkata")}

        :Working ->
          %{status: "Completed", end_time: Timex.now("Asia/Kolkata")}

        _ ->
          %{}
      end

    if task.user.id == user.id do
      {:ok, _task} = Todo.update_task(task, task_params)

      conn
      |> put_flash(:info, "Task updated successfully.")
      |> redirect(to: Routes.task_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Access denied")
      |> redirect(to: Routes.task_path(conn, :index))
    end
  end
end
