atom_feed(:root_url => url_for(:controller => :posts, :action => :index, only_path: false)) do |feed|
  feed.title(snippet(:site_name) || "Mazavr Blog")
  feed.updated(@posts[0].created_at) if @posts.length > 0

  @posts.each do |post|
    feed.entry(post, :url => smart_post_url(post, utm_source: params[:utm_source], utm_medium: params[:utm_medium], utm_campaign: params[:utm_campaign])) do |entry|
      entry.id("post:#{post.id}")
      entry.title(post.title)

      if params[:short]
        case params[:short]
        when "1"
          entry.content(text_short(post.body, 500), type: 'html')
        when "0"
          # no content
        else
          entry.content(text_short(post.body, params[:short].to_i), type: 'html')
        end
      else
        entry.content(format_post(post.body), type: 'html')
      end

      entry.author do |author|
        author.name(post.blog.title)
      end
    end
  end
end

