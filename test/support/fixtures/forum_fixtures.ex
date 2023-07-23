defmodule Twitter.ForumFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Twitter.Forum` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        content: "some content",
        likes: 42,
        title: "some title",
        views: 42
      })
      |> Twitter.Forum.create_post()

    post
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        content: "some content",
        likes: 42
      })
      |> Twitter.Forum.create_comment()

    comment
  end

  @doc """
  Generate a unique category name.
  """
  def unique_category_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        name: unique_category_name()
      })
      |> Twitter.Forum.create_category()

    category
  end
end
