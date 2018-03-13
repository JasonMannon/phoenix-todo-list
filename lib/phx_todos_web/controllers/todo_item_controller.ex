require IEx;

defmodule PhxTodosWeb.TodoItemController do
  use PhxTodosWeb, :controller

  alias PhxTodos.Todo
  alias PhxTodos.Todo.TodoItem

  action_fallback PhxTodosWeb.FallbackController

  def index(conn, %{"status" => status}) do
    todo_items = Todo.filter_todo_items(status)
    render(conn, "index.json", todo_items: todo_items)
  end

  def create(conn, %{"todo_item" => todo_item_params}) do
    with {:ok, %TodoItem{} = todo_item} <- Todo.create_todo_item(todo_item_params) do
      todo_items = Todo.list_todo_items()
      conn
      |> put_status(:created)
      |> render("index.json", todo_items: todo_items)
    end
  end

  def show(conn, %{"id" => id}) do
    todo_item = Todo.get_todo_item!(id)
    render(conn, "show.json", todo_item: todo_item)
  end

  def update(conn, %{"id" => id, "todo_item" => todo_item_params}) do
    todo_item = Todo.get_todo_item!(id)

    with {:ok, %TodoItem{} = todo_item} <- Todo.update_todo_item(todo_item, todo_item_params) do
      render(conn, "show.json", todo_item: todo_item)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo_item = Todo.get_todo_item!(id)
    with {:ok, %TodoItem{}} <- Todo.delete_todo_item(todo_item) do
      send_resp(conn, :no_content, "")
    end
  end
end
