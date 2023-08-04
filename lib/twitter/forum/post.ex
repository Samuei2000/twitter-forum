defmodule Twitter.Forum.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :likes, :integer,default: 0
    field :title, :string
    field :views, :integer, default: 0
    #field :user_id, :id
    #field :category_id, :id
    belongs_to :user,Twitter.Accounts.User
    belongs_to :category,Twitter.Forum.Category
    many_to_many :like_user, Twitter.Accounts.User, join_through: "like"
    has_many :comments, Twitter.Forum.Comment
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :views,:likes])
    |> validate_required([:title, :content])
    |> validate_length(:title, min: 2, max: 100)
    |> validate_length(:content, min: 2, max: 100)
  end
end
