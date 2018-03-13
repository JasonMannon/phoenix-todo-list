defmodule PhxTodosWeb.TodoItemControllerTest do
  use PhxTodosWeb.ConnCase

  alias PhxTodos.Todo
  alias PhxTodos.Todo.TodoItem

  @create_attrs %{status: "active", title: "some title"}
  @create_completed_attrs %{status: "completed", title: "some title"}
  @update_attrs %{status: "completed", title: "some updated title"}
  @invalid_attrs %{status: nil, title: nil}

  def fixture(:active_todo_item) do
    {:ok, todo_item} = Todo.create_todo_item(@create_attrs)
    todo_item
  end

  def fixture(:completed_todo_item) do
    {:ok, todo_item} = Todo.create_todo_item(@create_completed_attrs)
    todo_item
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "active index" do
    setup [:create_active_todo_item]

    test "lists all active todo_items", %{conn: conn} do
      conn = get conn, todo_item_path(conn, :index, status: "active")
      assert length(json_response(conn, 200)["data"]) == 1
    end
  end

  describe "completed index" do
    setup [:create_completed_todo_item]

    test "lists all completed todo_items", %{conn: conn} do
      conn = get conn, todo_item_path(conn, :index, %{status: "completed"})
      assert length(json_response(conn, 200)["data"]) == 1
    end
  end

  describe "create todo_item" do
    test "renders todo_item when data is valid", %{conn: conn} do
      conn = post conn, todo_item_path(conn, :create), todo_item: @create_attrs
      assert length(json_response(conn, 201)["data"]) == 1
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, todo_item_path(conn, :create), todo_item: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update todo_item" do
    setup [:create_active_todo_item]

    test "renders todo_item when data is valid", %{conn: conn, todo_item: %TodoItem{id: id} = todo_item} do
      conn = put conn, todo_item_path(conn, :update, todo_item), todo_item: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, todo_item_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "status" => "completed",
        "title" => "some updated title"}
    end

    test "renders errors when data is invalid", %{conn: conn, todo_item: todo_item} do
      conn = put conn, todo_item_path(conn, :update, todo_item), todo_item: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete todo_item" do
    setup [:create_active_todo_item]

    test "deletes chosen todo_item", %{conn: conn, todo_item: todo_item} do
      conn = delete conn, todo_item_path(conn, :delete, todo_item)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, todo_item_path(conn, :show, todo_item)
      end
    end
  end

  defp create_active_todo_item(_) do
    todo_item = fixture(:active_todo_item)
    {:ok, todo_item: todo_item}
  end

  defp create_completed_todo_item(_) do
    todo_item = fixture(:completed_todo_item)
    {:ok, todo_item: todo_item}
  end
end
