defmodule PhxTodosWeb.TodoItemView do
  use PhxTodosWeb, :view
  alias PhxTodosWeb.TodoItemView

  def render("index.json", %{todo_items: todo_items}) do
    %{data: render_many(todo_items, TodoItemView, "todo_item.json")}
  end

  def render("show.json", %{todo_item: todo_item}) do
    %{data: render_one(todo_item, TodoItemView, "todo_item.json")}
  end

  def render("todo_item.json", %{todo_item: todo_item}) do
    %{id: todo_item.id,
      title: todo_item.title,
      status: todo_item.status}
  end
end
