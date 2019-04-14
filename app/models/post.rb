class Post < PostBase
  STREAM_PARTNERS = 'partners'.freeze

  def index_source?
    created_at > 1.year.ago
  end
end
