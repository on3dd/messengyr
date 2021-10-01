defmodule Messengyr.Auth.ErrorHandler do
  # TODO: bad practice, need to be refactored
  use MessengyrWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_flash(:error, "You need to log in to view your messages.")
    |> redirect(to: "/")
  end
end
