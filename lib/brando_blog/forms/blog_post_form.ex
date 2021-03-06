defmodule Brando.BlogPostForm do
  @moduledoc """
  A form for the BlogPost model. See the `Brando.Form` module for more
  documentation
  """

  use Brando.Form
  alias Brando.BlogPost
  import Brando.Blog.Gettext

  @doc false
  def get_language_choices() do
    Brando.config(:languages)
  end

  @doc false
  def get_status_choices() do
   [[value: "0", text: gettext("Draft")],
    [value: "1", text: gettext("Published")],
    [value: "2", text: gettext("Pending")],
    [value: "3", text: gettext("Deleted")]]
  end

  @doc """
  Check is status' choice is selected.
  Translates the `model_value` from an atom to an int as string
  through `Brando.Type.Status.dump/1`.
  Returns boolean.
  """
  @spec status_selected?(String.t, atom) :: boolean
  def status_selected?(form_value, model_value) do
    # translate value from atom to corresponding int as string
    {:ok, status_int} = Brando.Type.Status.dump(model_value)
    form_value == to_string(status_int)
  end

  form "blog_post", [schema: BlogPost, helper: :admin_blog_post_path, class: "grid-form"] do
    fieldset do
      field :language, :select,
        [default: "nb",
         choices: &__MODULE__.get_language_choices/0]
    end
    fieldset do
      field :status, :radio,
        [default: "2",
         choices: &__MODULE__.get_status_choices/0,
         is_selected: &__MODULE__.status_selected?/2]
    end
    fieldset do
      field :featured, :checkbox,
        [default: false]
    end
    fieldset do
      field :header, :text
      field :slug, :text, [slug_from: :header]
    end
    field :lead, :textarea, [required: false]
    field :data, :textarea, [required: false]
    fieldset do
      field :meta_description, :text
      field :meta_keywords, :text
    end
    field :publish_at, :datetime, [default: &Brando.Utils.get_now/0]
    field :tags, :text, [tags: true, required: false]
    submit :save, [class: "btn btn-success"]
  end
end
