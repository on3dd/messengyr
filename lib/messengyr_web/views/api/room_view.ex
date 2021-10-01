defmodule MessengyrWeb.RoomView do
  use MessengyrWeb, :view

  import MessengyrWeb.MessageView, only: [message_json: 2]
  import MessengyrWeb.UserView, only: [user_json: 1]

  def render("index.json", %{rooms: rooms, me: me}) do
    %{rooms: Enum.map(rooms, &room_json(&1, %{me: me}))}
  end

  def room_json(%{users: room_users} = room, %{me: me}) do
    counterpart = get_counterpart(room_users, me)

    %{
      id: room.id,
      counterpart: user_json(counterpart),
      messages: Enum.map(room.messages, &message_json(&1, %{me: me}))
    }
  end

  defp get_counterpart(users, me) do
    Enum.find(users, fn user -> user.id !== me.id end)
  end
end
