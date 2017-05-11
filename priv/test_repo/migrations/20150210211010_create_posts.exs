defmodule BrandoBlog.Integration.TestRepo.Migrations.CreateBlogPosts do
  use Ecto.Migration
  use Brando.Tag, :migration
  use Brando.Villain, :migration

  def up do
    create table(:blog_posts) do
      add :language,          :text
      add :header,            :text
      add :slug,              :text
      add :lead,              :text
      villain()
      add :cover,             :text
      add :status,            :integer
      add :creator_id,        references(:users)
      add :meta_description,  :text
      add :meta_keywords,     :text
      add :css_classes,       :text
      add :featured,          :boolean
      add :publish_at,        :datetime
      tags()
      timestamps()
    end
    create index(:blog_posts, [:language])
    create index(:blog_posts, [:slug])
    create index(:blog_posts, [:status])
    create index(:blog_posts, [:tags])
  end

  def down do
    drop table(:blog_posts)
    drop index(:blog_posts, [:language])
    drop index(:blog_posts, [:slug])
    drop index(:blog_posts, [:status])
  end
end
