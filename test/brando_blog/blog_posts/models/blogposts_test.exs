defmodule BrandoBlog.BlogPostTest do
  use ExUnit.Case
  use BrandoBlog.ModelCase

  alias Brando.BlogPost
  alias BrandoBlog.Factory

  setup do
    user = Factory.insert(:user)
    post = Factory.insert(:blog_post, creator: user)

    {:ok, %{user: user, post: post}}
  end

  test "meta", %{post: post} do
    assert BlogPost.__name__(:singular) == "blog post"
    assert BlogPost.__name__(:plural) == "blog posts"
    assert BlogPost.__repr__(post) == "BlogPost title"
  end

  test "encode_data" do
    assert BlogPost.encode_data(%{data: "test"}) == %{data: "test"}
    assert BlogPost.encode_data(%{data: [%{key: "value"}, %{key2: "value2"}]})
           == %{data: ~s([{"key":"value"},{"key2":"value2"}])}
  end
end
