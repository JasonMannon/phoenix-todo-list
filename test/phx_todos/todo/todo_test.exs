defmodule PhxTodos.TodoTest do
  use PhxTodos.DataCase

  alias PhxTodos.Todo

  describe "todo_items" do
    alias PhxTodos.Todo.TodoItem

    @valid_attrs %{status: "some status", title: "some title"}
    @update_attrs %{status: "some updated status", title: "some updated title"}
    @invalid_attrs %{status: nil, title: nil}

    def todo_item_fixture(attrs \\ %{}) do
      {:ok, todo_item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Todo.create_todo_item()

      todo_item
    end

    test "list_todo_items/0 returns all todo_items" do
      todo_item = todo_item_fixture()
      assert Todo.list_todo_items() == [todo_item]
    end

    test "get_todo_item!/1 returns the todo_item with given id" do
      todo_item = todo_item_fixture()
      assert Todo.get_todo_item!(todo_item.id) == todo_item
    end

    test "create_todo_item/1 with valid data creates a todo_item" do
      assert {:ok, %TodoItem{} = todo_item} = Todo.create_todo_item(@valid_attrs)
      assert todo_item.status == "some status"
      assert todo_item.title == "some title"
    end

    test "create_todo_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todo.create_todo_item(@invalid_attrs)
    end

    test "update_todo_item/2 with valid data updates the todo_item" do
      todo_item = todo_item_fixture()
      assert {:ok, todo_item} = Todo.update_todo_item(todo_item, @update_attrs)
      assert %TodoItem{} = todo_item
      assert todo_item.status == "some updated status"
      assert todo_item.title == "some updated title"
    end

    test "update_todo_item/2 with invalid data returns error changeset" do
      todo_item = todo_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Todo.update_todo_item(todo_item, @invalid_attrs)
      assert todo_item == Todo.get_todo_item!(todo_item.id)
    end

    test "delete_todo_item/1 deletes the todo_item" do
      todo_item = todo_item_fixture()
      assert {:ok, %TodoItem{}} = Todo.delete_todo_item(todo_item)
      assert_raise Ecto.NoResultsError, fn -> Todo.get_todo_item!(todo_item.id) end
    end

    test "change_todo_item/1 returns a todo_item changeset" do
      todo_item = todo_item_fixture()
      assert %Ecto.Changeset{} = Todo.change_todo_item(todo_item)
    end
  end
end
