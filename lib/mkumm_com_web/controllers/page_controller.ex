defmodule MkummComWeb.PageController do
  use MkummComWeb, :controller
  alias MkummCom.Blog

  def index(conn, _params) do
    posts = Blog.all_posts()
    render(conn, "index.html", posts: posts)
  end
  def now(conn, _params) do
    posts = Blog.all_posts()
    render(conn, "now.html", posts: posts)
  end
  def about(conn, _params) do
    posts = Blog.all_posts()
    render(conn, "about.html", posts: posts)
  end
  def likes(conn, _params) do
    posts = Blog.all_posts()
    render(conn, "likes.html", posts: posts)
  end

  def show(conn, params) do
    date =
      Map.get(params, "date")
      |> Date.from_iso8601!()
    id = Map.get(params, "id")

    post = Blog.get_post_by_date_and_id!(date, id)
    render(conn, "show.html", post: post, page_title: post.title)
  end
end
