defmodule MkummComWeb.PageController do
  use MkummComWeb, :controller
  alias MkummCom.Blog

  def index(conn, _params) do
    posts = Blog.live_posts()
    render(conn, "index.html", posts: posts, page_title: "Blog")
  end

  def now(conn, _params) do
    render(conn, "now.html", page_title: "Now Page")
  end

  def about(conn, _params) do
    render(conn, "about.html", page_title: "About")
  end

  def likes(conn, _params) do
    render(conn, "likes.html", page_title: "Likes")
  end

  def show(conn, params) do
    date =
      Map.get(params, "date")
      |> Date.from_iso8601!()

    id = Map.get(params, "id")

    post = Blog.get_post_by_date_and_id!(date, id)
    render(conn, "show.html", post: post, page_title: "Blog: " <> post.title)
  end
end
