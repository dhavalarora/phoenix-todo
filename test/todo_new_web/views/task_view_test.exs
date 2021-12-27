defmodule TodoNewWeb.TaskViewTest do
  use TodoNewWeb.ConnCase, async: true
  alias TodoNewWeb.TaskView

  test "time_spent/2 returns time difference" do
    start_time = Timex.now()
    end_time = Timex.shift(start_time, hours: 1, minutes: 10, seconds: 15)
    assert TaskView.time_spent(start_time, end_time) == "1h 10m 15s"
  end
end
