defmodule Chat.Message do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  schema "messages" do
    field(:message, :string)
    belongs_to(:user, Chat.Coherence.User)

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message])
    |> validate_required([:message])
  end

  def get_messages(limit \\ 20) do
    Chat.Message
    |> order_by(asc: :inserted_at)
    |> Chat.Repo.all(limit: limit)
  end
end
