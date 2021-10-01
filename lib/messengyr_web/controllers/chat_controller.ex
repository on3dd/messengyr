defmodule MessengyrWeb.ChatController do
  use MessengyrWeb, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def index(conn, _params) do
    render(conn)
  end
end
