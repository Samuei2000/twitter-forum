defmodule Twitter.Like do
  import Ecto.Query, warn: false

  alias Twitter.Repo
  def check_likes_for_user(%Twitter.Accounts.User{} = user) do
    user
    |> Ecto.assoc(:like_post)
    |> Repo.all
  end

  def get_row!(user_id,post_id), do: Repo.get_by(Likes, [user_id: user_id, post_id: post_id])

  def delete_row(%Likes{} = row) do
    Repo.delete(row)
  end

  def create_row(attrs \\ %{}) do
    %Likes{}
    |> Likes.changeset(attrs)
    |> Repo.insert()
  end
end
