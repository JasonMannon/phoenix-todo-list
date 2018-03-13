defmodule PhxTodos.Repo.Migrations.CreateTodoItems do
  use Ecto.Migration

  def change do
    create table(:todo_items) do
      add :title, :string
      add :status, :string

      timestamps()
    end

  end
end
