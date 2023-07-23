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
end
