defmodule Twitter.Forum.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    field :likes, :integer,default: 0
    # field :user_id, :id
    belongs_to :user,Twitter.Accounts.User
    # field :parent_post_id, :id
    belongs_to :post,Twitter.Forum.Post
    #field :parent_comment_id, :id
    many_to_many :relationships, Twitter.Forum.Comment, join_through: Twitter.Forum.Relationship

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :likes])
    |> validate_required([:content, :likes])
    |> validate_length(:content, min: 2, max: 200)
  end
end

defmodule Twitter.Forum.Relationship do
  use Ecto.Schema
  import Ecto.Changeset

  schema "relationships" do
    field :child_comment_id, :id
    field :parent_comment_id, :id
    timestamps()
  end

  def changeset(row, attrs) do
    row
    |> cast(attrs, [:child_comment_id, :parent_comment_id])
    |> validate_required([:child_comment_id, :parent_comment_id])
  end
end
