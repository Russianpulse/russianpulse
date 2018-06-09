module SnippetsHelper
  def snippet(key, variables = {}, options = {}, &block)
    snippet = Snippet.find_by_key(key)

    if snippet.present?
      snippet_body = if snippet.v2.present?
                       ab_variant? ? snippet.v2 : snippet.body
                     else
                       snippet.body
                     end

      if snippet_body.present?
        html = snippet_body.to_s

        template = Liquid::Template.parse(html) # Parses and compiles the template
        raw template.render(variables.stringify_keys)
      end
    elsif block_given?
      html = capture(&block)
      Snippet.create(key: key, body: html) unless options[:do_not_create_missing]

      html
    else
      Snippet.create(key: key).body unless options[:do_not_create_missing]
    end
  end
end
