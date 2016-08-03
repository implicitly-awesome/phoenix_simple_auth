defmodule SimpleAuth.PostController do
  use SimpleAuth.Web, :controller

  alias SimpleAuth.User
  alias SimpleAuth.Post

  plug :scrub_params, "post" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, %{"user_id" => user_id}, _current_user) do
    user = User |> Repo.get!(user_id)

    posts =
      user
      |> user_posts
      |> Repo.all
      |> Repo.preload(:user)

    render(conn, "index.html", posts: posts, user: user)
  end

  def show(conn, %{"user_id" => user_id, "id" => id}, _current_user) do
    user = User |> Repo.get!(user_id)

    post = user |> user_post_by_id(id) |> Repo.preload(:user)

    render(conn, "show.html", post: post, user: user)
  end

  def new(conn, _params, current_user) do
    changeset =
      current_user
      |> build_assoc(:posts)
      |> Post.changeset

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}, current_user) do
    changeset =
      current_user
      |> build_assoc(:posts)
      |> Post.changeset(post_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Post was created successfully")
        |> redirect(to: user_post_path(conn, :index, current_user.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    post = current_user |> user_post_by_id(id)

    if post do
      changeset = Post.changeset(post)

      render(conn, "edit.html", post: post, changeset: changeset)
    else
      conn
      |> put_status(:not_found)
      |> render(SimpleAuth.ErrorView, "404.html")
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}, current_user) do
    post = current_user |> user_post_by_id(id)

    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Post was updated successfully")
        |> redirect(to: user_post_path(conn, :show, current_user.id, post.id))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => id}, current_user) do
    user = User |> Repo.get!(user_id)

    post = user |> user_post_by_id(id) |> Repo.preload(:user)

    if current_user.id == post.user.id || current_user.is_admin do
      Repo.delete!(post)

      conn
      |> put_flash(:info, "Post was deleted successfully")
      |> redirect(to: user_post_path(conn, :index, user.id))
    else
      conn
      |> put_flash(:info, "You can't delete this post")
      |> redirect(to: user_post_path(conn, :show, user.id, post.id))
    end
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
