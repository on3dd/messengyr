defmodule Messengyr.Chat do
  alias Messengyr.Chat.{Message, Room, RoomUser}
  alias Messengyr.Repo
  alias Messengyr.Accounts.User

  import Ecto.Query

  def get_room(id) do
    Repo.get(Room, id)
  end

  def create_room do
    %Room{} |> Repo.insert()
  end

  def create_room_with_counterpart(me, counterpart_username) do
    counterpart = Repo.get_by!(User, username: counterpart_username)
    room_members = [me, counterpart]

    with {:ok, room} <- create_room() do
      add_room_users(room, room_members)
    end
  end

  def add_room_user(room, user) do
    room_user = %RoomUser{
      room: room,
      user: user
    }

    Repo.insert(room_user)
  end

  defp add_room_users(room, []) do
    {:ok, room |> preload_room_data}
  end

  defp add_room_users(room, [head | tail]) do
    case add_room_user(room, head) do
      {:ok, _} ->
        add_room_users(room, tail)

      _ ->
        {:error, "Failed to add user to room!"}
    end
  end

  def add_message(%{room: room, user: user, text: text}) do
    message = %Message{
      room: room,
      user: user,
      text: text
    }

    Repo.insert(message)
  end

  def list_rooms do
    Repo.all(Room) |> preload_room_data
  end

  def list_user_rooms(user) do
    query =
      from r in Room,
        join: u in assoc(r, :users),
        where: u.id == ^user.id

    Repo.all(query) |> preload_room_data
  end

  def room_has_user?(room, user) do
    query =
      from ru in RoomUser,
        where: ru.room_id == ^room.id and ru.user_id == ^user.id

    case Repo.one(query) do
      %RoomUser{} -> true
      _ -> false
    end
  end

  defp preload_room_data(room) do
    room |> Repo.preload(:messages) |> Repo.preload(:users)
  end
end
