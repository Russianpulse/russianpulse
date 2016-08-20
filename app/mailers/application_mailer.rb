class ApplicationMailer < ActionMailer::Base
  default from: ENV['SERVER_EMAIL_ADDRESS']
  layout 'mailer'
end
