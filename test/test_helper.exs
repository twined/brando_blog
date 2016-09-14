Code.require_file("support/router_helper.exs", __DIR__)

{:ok, _} = Application.ensure_all_started(:brando)
{:ok, _} = Application.ensure_all_started(:ecto)
{:ok, _} = Application.ensure_all_started(:ex_machina)

Brando.Registry.wipe()
Brando.Registry.register(Brando.Blog)

ExUnit.start()

defmodule BrandoBlog.Integration.TestRepo do
  use Ecto.Repo, otp_app: :brando_blog
end

defmodule BrandoBlog.Integration.Endpoint do
  use Phoenix.Endpoint,
    otp_app: :brando_blog

  plug Plug.Session,
    store: :cookie,
    key: "_test",
    signing_salt: "signingsalt"

  plug Plug.Static,
    at: "/", from: :brando_blog, gzip: false,
    only: ~w(css images js fonts favicon.ico robots.txt),
    cache_control_for_vsn_requests: nil,
    cache_control_for_etags: nil
end

Mix.Task.run "ecto.create", ["-r", Brando.repo, "--quiet"]
Mix.Task.run "ecto.migrate", ["-r", Brando.repo, "--quiet"]

Brando.repo.start_link()

Ecto.Adapters.SQL.Sandbox.mode(Brando.repo, :manual)

Brando.endpoint.start_link
