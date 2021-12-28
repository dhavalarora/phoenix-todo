[![Elixir CI](https://github.com/dhavalarora/phoenix-todo/actions/workflows/elixir.yml/badge.svg)](
https://github.com/dhavalarora/phoenix-todo/actions/workflows/elixir.yml)

# Phoenix todo-app

This project is a to-do list management app. It is built using phoenix framework for Elixir with postgress as DB.

App provides below functionalities:
  * Register / Login
  * Add a new task
  * Update an existing task
  * Delete a task
  * List all tasks
  * Mark tasks as New / Working / Completed
  * Shows completion time for each tasks
  * Filter tasks by status

Once task is created, user can specify when he/she started working on that task and when was it completed. 
App will show list of tasks with their start/end time as well as time worked on each of them.
User can also filter tasks according to it's status.

UI view:

<img width="727" alt="image" src="https://user-images.githubusercontent.com/50210698/147490886-2402612c-0529-413d-99e3-880bd562df35.png">


### Setup and Installation:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

