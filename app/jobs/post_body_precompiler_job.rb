class PostBodyPrecompilerJob < ActiveJob::Base
  queue_as :low

  def perform(post)
    post.body_precompiled = HtmlCleanup.new(post.source_html).cleanup
    post.save!
  end
end
