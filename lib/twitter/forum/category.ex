defmodule Twitter.Forum.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string

    has_many :posts, Twitter.Forum.Post
    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
