defmodule Chat.RoomChannel do
  use Phoenix.Channel
  alias Chat.Repo
  alias Chat.Coherence.User
  alias Chat.Message
  alias ChatWeb.Presence

  def join("room", _payload, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    Message.get_messages()
    |> Enum.each(fn msg ->
      push(socket, "message:new", %{
        user: Repo.get(User, msg.user_id).name,
        message: msg.message
      })
    end)

    user = Repo.get(User, socket.assigns.user_id)
    push(socket, "presence_state", Presence.list(socket))

    {:ok, _} =
      Presence.track(socket, user.name, %{
        online_at: inspect(System.system_time(:seconds))
      })

    IO.inspect(Presence.list(socket))
    {:noreply, socket}
  end

  def handle_in("message:new", payload, socket) do
    user = Repo.get(User, socket.assigns.user_id)

    IO.puts("Building Changeset\n\n\n\n")

    changeset =
      user
      |> Ecto.build_assoc(:messages)
      |> Chat.Message.changeset(%{message: payload["message"]})

    IO.puts("Inserting changeset\n\n\n\n")
    Chat.Repo.insert(changeset)

    broadcast!(socket, "message:new", %{user: user.name, message: payload["message"]})
    {:noreply, socket}
  end
end
