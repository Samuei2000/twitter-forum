defmodule TwitterWeb.PostLive do
  use TwitterWeb, :live_view

  def render(assigns) do
    ~H"""
      <%= if @post != nil do %>
          <h1><%= @post.title %></h1>
          <br>
          <p><%= @post.content %></p>
          <br>
          <p>likes:<%= @post.likes %></p>
          <br>

          <%!-- <.table id="users" rows={@comments}>
            <:col :let={comment} label="Comments"><%= comment.content %></:col>

            <:action :let={comment}>
                <.button phx-click="comment" phx-value-comment={comment.id}>Comment</.button>
            </:action>
          </.table> --%>
        <%= if assigns.current_user !=nil do%>
          <.form for={@form} phx-submit="save">
            <.input field={@form[:content]} type="textarea"placeholder="Your Comment" />
            <button type="submit" class="bg-zinc-900 hover:bg-zinc-700 text-white font-bold py-2 px-4 rounded mt-3" phx-disable-with="Saving...">Comment</button>
          </.form>
          <br>
            <%= if @flag do%>
              <.button phx-click="unlike">UnLike</.button>
            <% else %>
              <.button phx-click="like">Like This Post</.button>
            <% end %>
        <% end %>
          <%= for comment <- @comments do %>
            <div class="bg-white p-5 rounded-lg shadow mb-3">
              <div class="flex justify-between items-center">
                <div class="flex items-center">
                  <div class="ml-3">
                    <h2 class="font-bold text-lg">@<%= comment.user.username %></h2>
                    <p class="text-gray-400 ml-2"><%= comment_inserted_at(comment) %></p>

                  </div>
                </div>
              </div>
              <p class="mt-3 text-gray-700">
                <%= comment.content %>
              </p>
              <.button phx-click="comment" phx-value-comment={comment.id}>Comment</.button>
            </div>
          <% end %>
          <br>

      <% else %>
        <div class="text-center py-10">
          <h2 class="text-gray-500 text-2xl">Nothing to see!</h2>
          <p class="text-gray-400">This category is empty.</p>
        </div>
      <% end %>
    """
  end

  on_mount {TwitterWeb.UserAuth, :mount_current_user}
  import Ecto.Query
  def mount(%{"category_name" => category_name,"post_id" => post_id}, _session, socket) do
    case Twitter.Forum.get_category_by_category_name(category_name) do
      nil -> {:ok, push_navigate(socket, to: "/*path")}
      category -> posts= Twitter.Forum.list_posts_for_category(%Twitter.Forum.Category{} = category)
                  posts_id= Enum.map(posts,fn x->x.id end)
                  {post_real_id, ""}=Integer.parse(post_id)
                  case post_real_id in posts_id do
                    false ->
                      {:ok, push_navigate(socket, to: "/*path")}
                    true -> post= Twitter.Forum.get_post!(post_id)
                            query = from c in Twitter.Forum.Comment, join: r in Twitter.Forum.Relationship,on: c.id==r.parent_comment_id,where: r.parent_comment_id==r.child_comment_id and c.post_id==^post_id
                            query =query |> preload(:user)
                            comments=Twitter.Repo.all(query)
                            likes= case socket.assigns.current_user do
                              nil -> nil
                              _ -> Twitter.Like.check_likes_for_user(socket.assigns.current_user)
                            end
                            flag= case likes do
                              nil -> nil
                              _ -> post in likes
                            end
                            form = %Twitter.Forum.Comment{} |> Ecto.Changeset.change() |> to_form
                            {:ok, assign(socket,post: post,form: form,flag: flag,like_num: post.likes, comments: comments,category_name: category_name)}
                  end
    end

  end

  def handle_event("unlike", _unsigned_params, socket) do
    Twitter.Forum.update_post(socket.assigns.post,%{likes: socket.assigns.post.likes-1})
    user_id=socket.assigns.current_user.id
    post_id=socket.assigns.post.id
    row=Twitter.Like.get_row!(user_id,post_id)
    Twitter.Like.delete_row(row)


    socket=Phoenix.Component.update(socket, :post, fn _ ->  Twitter.Forum.get_post!(post_id) end)
    {:noreply, Phoenix.Component.update(socket, :flag, fn _->  false end)}
  end

  def handle_event("like", _unsigned_params, socket) do
    Twitter.Forum.update_post(socket.assigns.post,%{likes: socket.assigns.post.likes+1})
    user_id=socket.assigns.current_user.id
    post_id=socket.assigns.post.id
    Twitter.Like.create_row(%{user_id: user_id,post_id: post_id})

    socket=Phoenix.Component.update(socket, :post, fn _ ->  Twitter.Forum.get_post!(post_id) end)
    {:noreply, Phoenix.Component.update(socket, :flag, fn _->  true end)}
  end

  def handle_event("save", %{"comment"=> comment_params}, socket) do
    user=socket.assigns.current_user
    post=socket.assigns.post
    case Twitter.Forum.create_comment_for_user(user,comment_params,post.id) do
      {:ok,comment} ->
        Twitter.Forum.create_child_for_parent(comment,comment)
        socket=Phoenix.Component.update(socket, :form, fn _ -> %Twitter.Forum.Comment{} |> Ecto.Changeset.change() |> to_form end)
        {:noreply, Phoenix.Component.update(socket, :comments, fn comments-> [comment | comments] end)}
      {:error,%Ecto.Changeset{} = changeset} -> {:noreply, assign(socket, form: to_form(changeset))}
    end


  end

  def handle_event("comment", %{"comment" => comment_params }, socket) do
    post=socket.assigns.post
    {:noreply, push_navigate(socket, to: ~p"/category/#{socket.assigns.category_name}/posts/#{post.id}/comments/#{comment_params}")}
  end

  def comment_inserted_at(%Twitter.Forum.Comment{inserted_at: timestamp}) do

    Calendar.strftime(timestamp, "%m/%d/%Y %I:%M%p")

  end
end
