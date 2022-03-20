defmodule MkummCom.Blog do
  alias MkummCom.Blog.Post
  use NimblePublisher,
    build: Post,
    from: "lib/posts/**/*.md",
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_erlang]

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})

  @tags @posts |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  def all_posts, do: @posts
  def all_tags, do: @tags

  def live_posts do
    all_posts()
    |> Enum.filter(& &1.publish)
  end

  def get_post_by_date_and_id!(date, id) do
    Enum.find(all_posts(), & &1.id == id && &1.date == date) || raise NotFoundError, "post not found"
  end
end

defmodule NotFoundError do
  defexception [:message, plug_status: 404]
end
