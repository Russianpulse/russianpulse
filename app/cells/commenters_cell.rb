class CommentersCell < Cell::ViewModel
  include FlagIconsRails::Rails::ViewHelpers
  include UriHelper

  def show(options)
    limit = options[:limit]
    period = options[:period] || 1.year

    @users = User.find_by_sql <<-SQL

    SELECT users.*, c.comments AS comments
    FROM users
    JOIN (SELECT user_id, COUNT(1) as comments FROM comments WHERE created_at > '#{period.ago.to_s(:db)}' GROUP BY user_id) c
      ON c.user_id = users.id

    ORDER BY comments DESC

    LIMIT #{limit}

    SQL

    render
  end
end
