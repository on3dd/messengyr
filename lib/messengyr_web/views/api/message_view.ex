defmodule MessengyrWeb.MessageView do
  use MessengyrWeb, :view

  def message_json(message, %{me: me}) do
    %{
      id: message.id,
      text: message.text,
      sent_at: message.inserted_at,
      outgoing: outgoing?(message, me)
    }
  end

  defp outgoing?(message, me) do
    message.user_id == me.id
  end
end
