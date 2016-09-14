defmodule BrandoBlog.RoutesTest do
  use ExUnit.Case

  setup do
    routes =
      Phoenix.Router.ConsoleFormatter.format(Brando.router)
    {:ok, [routes: routes]}
  end

  test "blog_resources", %{routes: routes} do
    assert routes =~ "/admin/blog/new"
    assert routes =~ "/admin/blog/:id/edit"
  end
end
