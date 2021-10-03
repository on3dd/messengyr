defmodule MessengyrWeb.ChatController do
  @moduledoc """
  The controller for the Messaging page,
  available only for logged-in users
  """

  use MessengyrWeb, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def index(conn, _params) do
    render(conn)
  end
end
