class AbTest < ActiveRecord::Base
  def match?(request_path)
    request_path.match(ab_test.path)
  end
end
