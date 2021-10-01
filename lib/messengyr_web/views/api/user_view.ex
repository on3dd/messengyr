defmodule MessengyrWeb.UserView do
  use MessengyrWeb, :view

  def render("show.json", %{user: user}) do
    %{user: user_json(user)}
  end

  def user_json(%{email: email} = user) do
    hash_email =
      :crypto.hash(:md5, email)
      |> Base.encode16()
      |> String.downcase()

    avatar_url = "http://www.gravatar.com/avatar/#{hash_email}"

    %{
      id: user.id,
      username: user.username,
      avatarURL: avatar_url
    }
  end

  # TODO: handle this case
  def user_json(user) do
    IO.inspect(user)

    %{}
  end
end
