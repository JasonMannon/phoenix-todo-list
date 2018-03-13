defmodule PhxTodos.Todo.TodoItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_items" do
    field :status, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(todo_item, attrs) do
    todo_item
    |> cast(attrs, [:title, :status])
    |> validate_required([:title, :status])
  end
end
