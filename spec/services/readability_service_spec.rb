describe ReadabilityService do
  let(:service) { described_class.new }
  let(:rules) { [] }
  subject(:result) { service.call(input_html, rules) }

  let(:blog) { Blog.new }

  let(:input_html) do
    <<-HTML
      <title>Title</title>
      <body>
        <p class="post-body">
          Hi there! What do You think about this picture?
          <img src="#" />

          Bye there!

          <span class="social-buttons"><span>VK</span></span>
        </p>

        <div>footer text</div>
      </body>

    HTML
  end

  context do
    let(:rules) { ["remove regexp /what do\s?you/i"] }
    it 'should remove by regexp rule' do
      is_expected.not_to include('What do You')
    end
  end

  context do
    let(:rules) { ['remove css .social-buttons'] }
    it 'should remove by css rule' do
      is_expected.not_to include('VK')
    end
  end

  context do
    let(:rules) { ['select css .post-body'] }
    it 'should select by css rule' do
      is_expected.not_to include('footer')
    end
  end

  context do
    let(:rules) { [] }
    it { expect { subject }.not_to raise_error }
  end

  context 'when fetching from ftr.fivefilters.org' do
    let(:input_html) do
      <<-HTML
        <title>Title</title>
        <body>
          <p>
          Some text
          </p>
          <p><strong><a href="https://blockads.fivefilters.org">Let's block ads!</a></strong> <a href="https://github.com/fivefilters/block-ads/wiki/There-are-no-acceptable-ads">(Why?)</a></p>
        </body>

      HTML
    end

    it { expect { subject }.not_to raise_error }
    it { is_expected.not_to include('Let\'s block') }
    it { is_expected.not_to include('Why?') }
    it { is_expected.to include('Some text') }
  end
end
