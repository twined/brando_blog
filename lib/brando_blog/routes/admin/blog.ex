defmodule Brando.Blog.Routes.Admin do
  @moduledoc """
  Routes for Brando.Blog

  ## Usage:

  In `router.ex`

      scope "/admin", as: :admin do
        pipe_through :admin
        blog_routes "/blog", model: Brando.BlogPost

  """
  alias Brando.Admin.BlogPostController
  alias Brando.BlogPost
  import Brando.Villain.Routes.Admin

  @doc """
  Defines "RESTful" endpoints for the news resource.
  """
  defmacro blog_routes(path), do:
    add_blog_routes(path, BlogPostController, [])

  defp add_blog_routes(path, controller, opts) do
    map = Map.put(%{}, :model, Keyword.get(opts, :model, BlogPost))
    options = Keyword.put([], :private, Macro.escape(map))
    quote do
      path = unquote(path)
      ctrl = unquote(controller)
      opts = unquote(options)
      nil_opts = Keyword.put(opts, :as, nil)

      villain_routes path, ctrl

      get    "#{path}",            ctrl, :index,          opts
      get    "#{path}/new",        ctrl, :new,            opts
      get    "#{path}/rerender",   ctrl, :rerender,       opts
      get    "#{path}/:id",        ctrl, :show,           opts
      get    "#{path}/:id/edit",   ctrl, :edit,           opts
      get    "#{path}/:id/delete", ctrl, :delete_confirm, opts
      post   "#{path}",            ctrl, :create,         opts
      delete "#{path}/:id",        ctrl, :delete,         opts
      patch  "#{path}/:id",        ctrl, :update,         opts
      put    "#{path}/:id",        ctrl, :update,         nil_opts
    end
  end
end
