defmodule Likes do
  use Ecto.Schema
  import Ecto.Changeset

  schema "like" do
    belongs_to :user, Twitter.Accounts.User
    belongs_to :post, Twitter.Forum.Post
    timestamps()
  end

  def changeset(like, attrs) do
    like
    |> cast(attrs, [:user_id, :post_id])
    |> validate_required([:user_id, :post_id])
  end
end
