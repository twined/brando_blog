defmodule Brando.Admin.BlogPostController do
  @moduledoc """
  Controller for the Brando News module.
  """

  use Brando.Web, :controller
  use Brando.Villain, [:controller, [
    image_model: Brando.Image,
    series_model: Brando.ImageSeries]]

  import Brando.Blog.Gettext
  import Brando.Utils, only: [helpers: 1]
  import Brando.Utils.Model, only: [put_creator: 2]
  import Brando.Plug.HTML

  alias Brando.BlogPost

  plug :put_section, "blog"
  plug :scrub_params, "blog_post" when action in [:create, :update]

  @doc false
  def index(conn, _params) do
    posts =
      BlogPost
      |> BlogPost.order
      |> BlogPost.preload_creator
      |> Brando.repo.all

    conn
    |> assign(:page_title, gettext("Index - blog posts"))
    |> assign(:posts, posts)
    |> render(:index)
  end

  @doc false
  def rerender(conn, _params) do
    posts = Brando.repo.all(BlogPost)

    for post <- posts do
      BlogPost.rerender_html(BlogPost.changeset(post, :update, %{}))
    end

    conn
    |> put_flash(:notice, gettext("Blog posts re-rendered"))
    |> redirect(to: helpers(conn).admin_blog_post_path(conn, :index))
  end

  @doc false
  def show(conn, %{"id" => id}) do
    post =
      BlogPost
      |> BlogPost.preload_creator
      |> Brando.repo.get_by!(id: id)

    conn
    |> assign(:page_title, gettext("Show post"))
    |> assign(:post, post)
    |> render(:show)
  end

  @doc false
  def new(conn, _params) do
    changeset = BlogPost.changeset(%BlogPost{}, :create)

    conn
    |> assign(:changeset, changeset)
    |> assign(:page_title, gettext("New post"))
    |> render(:new)
  end

  @doc false
  def create(conn, %{"blog_post" => post}) do
    changeset =
      %BlogPost{}
      |> put_creator(Brando.Utils.current_user(conn))
      |> BlogPost.changeset(:create, post)

    case Brando.repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:notice, gettext("Blog post created"))
        |> redirect(to: router_module(conn).__helpers__.admin_blog_post_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:page_title, gettext("New post"))
        |> assign(:post, post)
        |> assign(:changeset, changeset)
        |> put_flash(:error, gettext("Errors in form"))
        |> render(:new)
    end
  end

  @doc false
  def edit(conn, %{"id" => id}) do
    changeset =
      BlogPost
      |> Brando.repo.get!(id)
      |> BlogPost.encode_data
      |> BlogPost.changeset(:update)

    conn
    |> assign(:page_title, gettext("Edit post"))
    |> assign(:changeset, changeset)
    |> assign(:id, id)
    |> render(:edit)
  end

  @doc false
  def update(conn, %{"blog_post" => post, "id" => id}) do
    changeset =
      BlogPost
      |> Brando.repo.get_by!(id: id)
      |> BlogPost.changeset(:update, post)

    case Brando.repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:notice, gettext("Blog post updated"))
        |> redirect(to: router_module(conn).__helpers__.admin_blog_post_path(conn, :index))

      {:error, changeset} ->
        conn
        |> assign(:id, id)
        |> assign(:post, post)
        |> assign(:changeset, changeset)
        |> assign(:page_title, gettext("Edit post"))
        |> put_flash(:error, gettext("Errors in form"))
        |> render(:edit)
    end
  end

  @doc false
  def delete_confirm(conn, %{"id" => id}) do
    record = Brando.repo.get_by!(BlogPost.preload_creator(BlogPost), id: id)

    conn
    |> assign(:page_title, gettext("Confirm deletion"))
    |> assign(:record, record)
    |> render(:delete_confirm)
  end

  @doc false
  def delete(conn, %{"id" => id}) do
    post = Brando.repo.get(BlogPost, id)

    {:ok, post} = Brando.Images.Utils.delete_original_and_sized_images(post, :cover)
    Brando.repo.delete!(post)

    conn
    |> put_flash(:notice, gettext("Blog post deleted"))
    |> redirect(to: router_module(conn).__helpers__.admin_blog_post_path(conn, :index))
  end
end
