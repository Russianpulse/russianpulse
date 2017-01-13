require 'i18n'
I18n.default_locale = :en

RailsAdmin.config do |config|
  config.excluded_models << 'PostArchived'

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'Blog' do
    configure :posts do
      hide
    end
  end

  config.model 'Tag' do
    configure :post_ids do
      hide
    end
  end

  config.authorize_with do
    authenticate_or_request_with_http_basic('Rails admin') do |username, password|
      username == (ENV['ADMIN_USERNAME'] || 'admin') && password == (ENV['ADMIN_PASSWORD'] || 'secret')
    end
  end
end
