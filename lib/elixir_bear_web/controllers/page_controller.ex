defmodule ElixirBearWeb.PageController do
  use ElixirBearWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
