# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Chat.Repo.insert!(%Chat.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Chat.Repo.delete_all(Chat.Coherence.User)

Chat.Coherence.User.changeset(%Chat.Coherence.User{}, %{
  name: "Test",
  email: "test@test.com",
  password: "secret",
  password_confirmation: "secret"
})
|> Chat.Repo.insert!()
