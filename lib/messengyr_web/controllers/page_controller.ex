defmodule MessengyrWeb.PageController do
  use MessengyrWeb, :controller

  def index(conn, _params), do: render(conn)

  def login(conn, _params), do: render(conn)

  def signup(conn, _params), do: render(conn)
end
