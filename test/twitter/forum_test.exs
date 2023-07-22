defmodule Twitter.ForumTest do
  use Twitter.DataCase

  alias Twitter.Forum

  describe "posts" do
    alias Twitter.Forum.Post

    import Twitter.ForumFixtures

    @invalid_attrs %{content: nil, likes: nil, title: nil, views: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Forum.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Forum.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{content: "some content", likes: 42, title: "some title", views: 42}

      assert {:ok, %Post{} = post} = Forum.create_post(valid_attrs)
      assert post.content == "some content"
      assert post.likes == 42
      assert post.title == "some title"
      assert post.views == 42
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{content: "some updated content", likes: 43, title: "some updated title", views: 43}

      assert {:ok, %Post{} = post} = Forum.update_post(post, update_attrs)
      assert post.content == "some updated content"
      assert post.likes == 43
      assert post.title == "some updated title"
      assert post.views == 43
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_post(post, @invalid_attrs)
      assert post == Forum.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Forum.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Forum.change_post(post)
    end
  end
end
