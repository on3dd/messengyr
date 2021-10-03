defmodule MessengyrWeb.RoomView do
  @moduledoc """
  Renders Room structs in a given format.
  """

  use MessengyrWeb, :view

  import MessengyrWeb.MessageView, only: [message_json: 2]
  import MessengyrWeb.UserView, only: [user_json: 1]

  @doc """
  Renders one or multiple Rooms in JSON format.

  ## Parameters

    - *template*: either `"show.json"` (for one) or `"index.json"` (for multiple)
    - *assigns*: a map that must contain the following keys-value pairs:
    - `:room` (or `:rooms`) => one or multiple `Room` structs
    - `:me` => a `User` struct
  """
  def render("index.json", %{rooms: rooms, me: me}) do
    %{rooms: Enum.map(rooms, &room_json(&1, %{me: me}))}
  end

  def render("show.json", %{room: room, me: me}) do
    %{room: room_json(room, %{me: me})}
  end

  def room_json(%{users: room_users} = room, %{me: me}) do
    counterpart = get_counterpart(room_users, me)

    %{
      id: room.id,
      created_at: room.inserted_at,
      counterpart: user_json(counterpart),
      messages: Enum.map(room.messages, &message_json(&1, %{me: me}))
    }
  end

  defp get_counterpart(users, me) do
    Enum.find(users, fn user -> user.id !== me.id end)
  end
end
