module SnippetsHelper
  def snippet(key, _variables = {}, options = {}, &block)
    snippet = Snippet.find_by(key: key)

    if snippet.present?
      snippet_body = if snippet.v2.present?
                       ab_variant? ? snippet.v2 : snippet.body
                     else
                       snippet.body
                     end

      raw snippet_body.to_s if snippet_body.present?
    elsif block_given?
      html = capture(&block)
      Snippet.create(key: key, body: html) unless options[:do_not_create_missing]

      html
    else
      Snippet.create(key: key).body unless options[:do_not_create_missing]
    end
  end
end
