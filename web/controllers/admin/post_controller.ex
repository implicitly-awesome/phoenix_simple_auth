defmodule SimpleAuth.Admin.PostController do
  use SimpleAuth.Web, :controller

  alias SimpleAuth.User

  def index(conn, %{"user_id" => user_id}) do
    user = user_id |> user_by_id
    posts = user |> user_posts |> Repo.all

    render(conn, "index.html", posts: posts, user: user)
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    user = user_id |> user_by_id
    post = user |> user_post_by_id(id) |> Repo.preload(:user)

    render(conn, "show.html", post: post, user: user)
  end

  defp user_by_id(user_id) do
    User |> Repo.get(user_id)
  end

  defp user_posts(user) do
    assoc(user, :posts)
  end

  defp user_post_by_id(user, post_id) do
    user
    |> user_posts
    |> Repo.get(post_id)
  end
end
