defmodule MessengyrWeb.UserController do
  use MessengyrWeb, :controller

  alias Messengyr.Accounts

  action_fallback MessengyrWeb.FallbackController

  def show(conn, %{"id" => user_id}) do
    user = Accounts.get_user(user_id)

    if user do
      render(conn, "show.json", user: user)
    end
  end
end
