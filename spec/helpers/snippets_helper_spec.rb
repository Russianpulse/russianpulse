require 'rails_helper'

RSpec.describe SnippetsHelper, type: :helper do
  before do
    Snippet.create(key: :foo, body: '{% if ads == true %}ADS{% endif %}')
  end

  subject { helper.snippet(:foo, options) }
  let(:options) { {} }

  it { is_expected.to be_blank }

  context do
    before { options.merge!(ads: true) }
    it { is_expected.to eq 'ADS' }
  end
end
