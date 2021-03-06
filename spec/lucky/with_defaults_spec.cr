require "../spec_helper"

private class TestWithDefaultsPage
  include Lucky::HTMLPage

  def render
    with_defaults field: name_field, class: "form-control" do |html|
      html.text_input
    end

    with_defaults field: name_field, class: "form-control" do |html|
      html.text_input placeholder: "Name please"
    end

    with_defaults field: name_field, placeholder: "default" do |html|
      html.text_input placeholder: "replace default"
    end

    with_defaults field: name_field, class: "default" do |html|
      html.text_input append_class: "appended classes"
    end

    with_defaults field: name_field, class: "default" do |html|
      html.text_input replace_class: "replaced"
    end

    # No default 'class'
    with_defaults field: name_field do |html|
      html.text_input append_class: "appended-without-default"
    end

    with_defaults field: name_field do |html|
      html.text_input replace_class: "replaced-without-default"
    end

    # tags that have content
    with_defaults class: "default" do |html|
      html.div "text content"
    end

    with_defaults class: "default" do |html|
      html.div do
        text "block content"
      end
    end

    view
  end
end

describe "with_defaults" do
  it "renders the component" do
    contents = TestWithDefaultsPage.new(build_context).render.to_s

    contents
      .should contain %(<input type="text" id="user_name" name="user:name" value="" class="form-control">)
    contents
      .should contain %(<input type="text" id="user_name" name="user:name" value="" class="form-control" placeholder="Name please">)
    contents
      .should contain %(<input type="text" id="user_name" name="user:name" value="" placeholder="replace default">)
    contents
      .should contain %(<input type="text" id="user_name" name="user:name" value="" class="default appended classes">)
    contents
      .should contain %(<input type="text" id="user_name" name="user:name" value="" class="replaced">)
    contents
      .should contain %(<input type="text" id="user_name" name="user:name" value="" class="appended-without-default">)
    contents
      .should contain %(<input type="text" id="user_name" name="user:name" value="" class="replaced-without-default">)
    contents
      .should contain %(<div class="default">text content</div>)
    contents
      .should contain %(<div class="default">block content</div>)
  end
end

private def name_field
  Avram::PermittedAttribute(String).new(
    name: :name,
    param: "",
    value: "",
    param_key: "user"
  )
end
