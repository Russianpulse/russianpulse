require 'sucker_punch/async_syntax'

SuckerPunch.exception_handler = -> (ex, klass, args) do
  Rails.logger.error ex
  NewRelic::Agent.notice_error(ex)
end

