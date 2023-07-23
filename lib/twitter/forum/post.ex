defmodule Twitter.Forum.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :likes, :integer
    field :title, :string
    field :views, :integer
    field :user_id, :id
    #field :category_id, :id

    belongs_to :category,Twitter.Forum.Category
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :views, :likes])
    |> validate_required([:title, :content, :views, :likes])
  end
end
