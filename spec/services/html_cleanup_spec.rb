require 'rails_helper'

RSpec.describe HtmlCleanup do
  subject { HtmlCleanup.new(source_html).cleanup }

  context do
    let(:source_html) { '<p>Text</p>' }
    it { is_expected.to match('Text') }
  end

  context do
    let(:source_html) { '<p>  </p>' }
    it { is_expected.not_to match('<p') }
  end

  context do
    let(:source_html) { '<p>&nbsp;</p>' }
    it { is_expected.not_to match('<p') }
  end

  context do
    let(:source_html) { '<p><img src='' /></p>' }
    it { is_expected.to match('img') }
  end

  context do
    let(:source_html) { '<p><video src='' /></p>' }
    it { is_expected.to match('video') }
  end

  context do
    let(:source_html) { '<p><iframe src='' /></p>' }
    it { is_expected.to match('iframe') }
  end

  context do
    let(:source_html) { '<p>Small text</p>' }
    it { is_expected.to match(/class=\"tiny\"/) }
  end
  context do
    let(:source_html) { '<div>Text</div>' }
    it { is_expected.not_to match('<div>') }
  end
  context do
    let(:source_html) { 'Text<br /><br>Next line' }
    it { is_expected.not_to match('br') }
  end


  describe 'headers' do
    context do
      let(:source_html) { '<h1>Header</h1>' }
      it { is_expected.to match('<h2>Header</h2>') }
    end

    context do
      let(:source_html) { '<h3>Header</h3>' }
      it { is_expected.to match('<h2>Header</h2>') }
    end

    context do
      let(:source_html) { '<h4>Header</h4>' }
      it { is_expected.to match('<h2>Header</h2>') }
    end
    context do
      let(:source_html) { '<h3>Header Big</h3><h4>Header Small</h4>' }
      it { is_expected.to match('<h3>Header Small</h3>') }
    end
  end
end

