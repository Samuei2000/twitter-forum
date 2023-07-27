defmodule Twitter.Forum.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    field :likes, :integer,default: 0
    field :user_id, :id
    field :parent_post_id, :id
    field :parent_comment_id, :id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :likes])
    |> validate_required([:content, :likes])
  end
end
