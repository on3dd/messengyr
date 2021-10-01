defmodule MessengyrWeb.RoomController do
  use MessengyrWeb, :controller

  alias Messengyr.Chat

  action_fallback MessengyrWeb.FallbackController

  def index(conn, _params) do
    rooms = Chat.list_rooms()
    user = Guardian.Plug.current_resource(conn)

    render(conn, "index.json", %{rooms: rooms, me: user})
  end
end
