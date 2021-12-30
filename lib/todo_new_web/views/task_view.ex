defmodule TodoNewWeb.TaskView do
  use TodoNewWeb, :view

  def time_spent(start_time, end_time) do
    diff = Timex.diff(end_time, start_time, :seconds)
    hours = div(diff, 3600)
    minutes = div(diff - 3600 * hours, 60)
    seconds = diff - 3600 * hours - 60 * minutes
    to_string(hours) <> "h " <> to_string(minutes) <> "m " <> to_string(seconds) <> "s"
  end

  def filter(tasks, str) do
    case str do
      "all" -> tasks
      "new" -> Enum.filter(tasks, fn t -> t.status == :New end)
      "working" -> Enum.filter(tasks, fn t -> t.status == :Working end)
      "completed" -> Enum.filter(tasks, fn t -> t.status == :Completed end)
      _ -> tasks
    end
  end

  def selected(filter, str) do
    case filter == str do
      true -> "selected"
      false -> ""
    end
  end
end
