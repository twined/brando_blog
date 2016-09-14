defmodule Brando.Blog.Menu do
  @moduledoc """
  Menu definitions for the Blog Menu. See `Brando.Menu` docs for
  more information
  """
  use Brando.Menu
  import Brando.Blog.Gettext

  menu %{
    name: gettext("Blog"), anchor: "blog", icon: "fa fa-book icon",
      submenu: [%{name: gettext("Index"), url: {:admin_blog_post_path, :index}},
                %{name: gettext("Add new"), url: {:admin_blog_post_path, :new}}]}
end
