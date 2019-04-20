module SnippetsHelper
  def snippet(key)
    Rails.cache.fetch "snippet:#{key}:#{ab_variant?}", expires_in: 1.minute do
      snippet = Snippet.find_by(key: key)

      if snippet.present?
        body = if ab_variant?
                 snippet.v2.presence || snippet.body
               else
                 snippet.body
               end

        raw body.to_s
      end
    end
  end
end
