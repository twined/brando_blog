use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :brando_blog, BrandoBlog.Integration.Endpoint,
  http: [port: 4001],
  server: false,
  secret_key_base: "verysecret"

config :logger, level: :warn

config :brando_blog, BrandoBlog.Integration.TestRepo,
  url: "ecto://postgres:postgres@localhost/brando_blog_test",
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  max_overflow: 0

config :brando, :router, BrandoBlog.Router
config :brando, :endpoint, BrandoBlog.Integration.Endpoint
config :brando, :repo, BrandoBlog.Integration.TestRepo
config :brando, :helpers, BrandoBlog.Router.Helpers

config :brando, Brando.Menu, [
  modules: [Brando.Blog.Menu],
  colors: ["#FBA026;", "#F87117;", "#CF3510;", "#890606;", "#FF1B79;",
           "#520E24;", "#8F2041;", "#DC554F;", "#FF905E;", "#FAC51C;",
           "#D6145F;", "#AA0D43;", "#7A0623;", "#430202;", "#500422;",
           "#870B46;", "#D0201A;", "#FF641A;"]]

config :brando, Brando.Villain, parser: Brando.Villain.Parser.Default
config :brando, Brando.Villain, extra_blocks: []

config :brando, :default_language, "nb"
config :brando, :admin_default_language, "nb"
config :brando, :languages, [
  [value: "nb", text: "Norsk"],
  [value: "en", text: "English"]
]
config :brando, :admin_languages, [
  [value: "nb", text: "Norsk"],
  [value: "en", text: "English"]
]

# Configure Guardian for auth.
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "BrandoTesting",
  ttl: {30, :days},
  verify_issuer: true, # optional
  secret_key: "XX9ND0BmT51mrKWp46WdYZoPWOv6awnEScbNg3HPWTnnl605tmDKEogZCb9109gb",
  serializer: Brando.GuardianSerializer
