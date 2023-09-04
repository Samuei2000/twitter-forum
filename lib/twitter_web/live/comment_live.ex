defmodule TwitterWeb.CommentLive do
  use TwitterWeb, :live_view
  import Ecto.Query

  def render(assigns) do
    ~H"""
    <%= for comment <- @child_comments do %>
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
      </div>
    <% end %>
    <%= if assigns.current_user !=nil do%>
      <.form for={@form} phx-submit="save">
        <.input field={@form[:content]} type="textarea"placeholder="Your Comment" />
        <button type="submit" class="bg-zinc-900 hover:bg-zinc-700 text-white font-bold py-2 px-4 rounded mt-3" phx-disable-with="Saving...">Comment</button>
      </.form>
    <% end %>
    """
  end

  on_mount {TwitterWeb.UserAuth, :mount_current_user}

  def mount(%{"category_name" => category_name,"post_id" => post_id,"comment_id" => comment_id}, _session, socket) do
    form = %Twitter.Forum.Comment{} |> Ecto.Changeset.change() |> to_form
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
                            comments_id=Enum.map(comments,fn x->x.id end)
                            {comment_real_id,""}=Integer.parse(comment_id)
                            case comment_real_id in comments_id do
                              false -> {:ok, push_navigate(socket, to: "/*path")}
                              true ->
                                parent_comment=Twitter.Forum.get_comment!(comment_id)
                                child_comments = case parent_comment do
                                      nil -> nil
                                      _ -> query = from c in Twitter.Forum.Comment, join: r in Twitter.Forum.Relationship,on: c.id==r.child_comment_id,where: r.parent_comment_id==^parent_comment.id and r.parent_comment_id != r.child_comment_id
                                          query = query |> preload(:user)
                                          Twitter.Repo.all(query)
                                end
                                socket=socket
                            |> assign(form: form)
                            |> assign(child_comments: child_comments)
                            |> assign(post: post)
                            |> assign(category_name: category_name)
                            |> assign(parent_comment: parent_comment)
                        {:ok, socket}
                            end


                  end

    end

    # {:ok,assign(socket,form: form,child_comments: child_comments,post: post,category_name: category_name,parent_comment: parent_comment)}
  end

  def handle_event("save", %{"comment"=> comment_params}, socket) do
    user=socket.assigns.current_user
    parent=socket.assigns.parent_comment
    post=socket.assigns.post
    case Twitter.Forum.create_comment_for_user(user,comment_params,post.id) do
      {:ok,%Twitter.Forum.Comment{}=comment}
        -> Twitter.Forum.create_child_for_parent(parent,comment)
        Twitter.Forum.update_comment(comment,%{parent_comment_id: parent.id})
        socket=Phoenix.Component.update(socket, :form, fn _ -> %Twitter.Forum.Comment{} |> Ecto.Changeset.change() |> to_form end)
        {:noreply,Phoenix.Component.update(socket, :child_comments, fn comments-> [comment | comments] end)}
      {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, form: to_form(changeset))}
    end

  end
  def comment_inserted_at(%Twitter.Forum.Comment{inserted_at: timestamp}) do

    Calendar.strftime(timestamp, "%m/%d/%Y %I:%M%p")

  end
end
