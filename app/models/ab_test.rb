class AbTest < ActiveRecord::Base
  def match?(request_path)
    return request_path == path if equal?

    request_path.match(path)
  end
end
