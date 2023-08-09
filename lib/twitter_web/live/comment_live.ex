defmodule TwitterWeb.CommentLive do
  use TwitterWeb, :live_view
  import Ecto.Query

  def render(assigns) do
    ~H"""
    <%= for cate <- @child_comments do %>
      <p><%= cate.content %></p>
      <br>
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
    parent_comment=Twitter.Forum.get_comment!(comment_id)
    child_comments = case parent_comment do
      nil -> nil
      _ -> query = from c in Twitter.Forum.Comment, join: r in Twitter.Forum.Relationship,on: c.id==r.child_comment_id,where: r.parent_comment_id==^parent_comment.id and r.parent_comment_id != r.child_comment_id
           Twitter.Repo.all(query)
    end
    post=Twitter.Forum.get_post!(post_id)
    {:ok,assign(socket,form: form,child_comments: child_comments,post: post,category_name: category_name,parent_comment: parent_comment)}
  end

  def handle_event("save", %{"comment"=> comment_params}, socket) do
    user=socket.assigns.current_user
    parent=socket.assigns.parent_comment
    post=socket.assigns.post
    case Twitter.Forum.create_comment_for_user(user,comment_params,post.id) do
      {:ok,%Twitter.Forum.Comment{}=comment}
        -> Twitter.Forum.create_child_for_parent(parent,comment)
        socket=Phoenix.Component.update(socket, :form, fn _ -> %Twitter.Forum.Comment{} |> Ecto.Changeset.change() |> to_form end)
        {:noreply,Phoenix.Component.update(socket, :child_comments, fn comments-> [comment | comments] end)}
      {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, form: to_form(changeset))}
    end

  end
end
