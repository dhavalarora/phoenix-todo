defmodule TodoNewWeb.TaskView do
  use TodoNewWeb, :view

  def time_spent(start_time, end_time) do
    # hours = Timex.diff(end_time, start_time, :hours)
    # remaining = Timex.shift(end_time, hours: -1 * hours)
    # minutes = Timex.diff( remaining, start_time, :minutes)
    # remaining = Timex.shift(remaining, minutes: -1 * minutes)
    diff = Timex.diff(end_time, start_time, :seconds)
    hours = div(diff, 3600)
    minutes = div(diff - 3600 * hours, 60)
    seconds = diff - 3600 * hours - 60 * minutes
    to_string(hours) <> "h " <> to_string(minutes) <> "m " <> to_string(seconds) <> "s"
  end
end
