defmodule TodoNewWeb.TaskViewTest do
  use TodoNewWeb.ConnCase, async: true
  alias TodoNewWeb.TaskView

  test "time_spent/2 returns time difference" do
    start_time = Timex.now()
    end_time = Timex.shift(start_time, hours: 1, minutes: 10, seconds: 15)
    assert TaskView.time_spent(start_time, end_time) == "1h 10m 15s"
  end

  test "filter/2 filters tasks according to status" do
    completed_task = %{status: :Completed}
    working_task = %{status: :Working}
    new_task = %{status: :New}
    task_list = [completed_task, completed_task, new_task, working_task, working_task, working_task]

    assert Enum.count(TaskView.filter(task_list, "new")) == 1
    assert Enum.count(TaskView.filter(task_list, "working")) == 3
    assert Enum.count(TaskView.filter(task_list, "completed")) == 2
  end

  test "selected/2 returns selected if filter is selected" do
    assert TaskView.selected("working", "working") == "selected"
    assert TaskView.selected("new", "working") == ""
  end
end
