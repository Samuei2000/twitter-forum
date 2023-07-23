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

  describe "comments" do
    alias Twitter.Forum.Comment

    import Twitter.ForumFixtures

    @invalid_attrs %{content: nil, likes: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Forum.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Forum.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{content: "some content", likes: 42}

      assert {:ok, %Comment{} = comment} = Forum.create_comment(valid_attrs)
      assert comment.content == "some content"
      assert comment.likes == 42
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{content: "some updated content", likes: 43}

      assert {:ok, %Comment{} = comment} = Forum.update_comment(comment, update_attrs)
      assert comment.content == "some updated content"
      assert comment.likes == 43
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_comment(comment, @invalid_attrs)
      assert comment == Forum.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Forum.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Forum.change_comment(comment)
    end
  end

  describe "categories" do
    alias Twitter.Forum.Category

    import Twitter.ForumFixtures

    @invalid_attrs %{name: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Forum.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Forum.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Category{} = category} = Forum.create_category(valid_attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Category{} = category} = Forum.update_category(category, update_attrs)
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_category(category, @invalid_attrs)
      assert category == Forum.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Forum.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Forum.change_category(category)
    end
  end
end
