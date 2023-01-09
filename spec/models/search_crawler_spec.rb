# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchCrawler do
  let(:url) { URI.join('file:///', Rails.public_path.join('test.html').to_s) }

  describe 'initialize' do
    it { expect { described_class.new([], '') }.not_to raise_error }
  end

  describe 'set_browser' do
    it 'set ferrum browser' do
      allow(Ferrum::Browser).to receive(:new).and_return('foo')
      expect(described_class.new([], '').set_browser).to eq('foo')
    end
  end

  describe 'user_agent_headers' do
    it 'return user_agent hash' do
      expect(described_class.new([], '').user_agent_headers.keys).to eq(['USER_AGENT'])
    end
  end

  describe '#results' do
    let(:keyword) { Fabricate.create(:keyword, name: 'cheap ticket') }
    let(:crawler) { described_class.new([keyword], url) }

    it { expect { crawler.results }.not_to raise_error }
    it { expect(crawler.results.class).to be(Array) }
    it { expect(crawler.results[0][:keyword_id]).to eq(keyword.id) }

    # rubocop:disable RSpec/StubbedMock, RSpec/MultipleExpectations, RSpec/AnyInstance
    it 'ensure exist browser' do
      expect_any_instance_of(Ferrum::Browser).to receive(:reset).and_return(true)
      expect_any_instance_of(Ferrum::Browser).to receive(:quit).and_return(true)
      crawler.results
    end
    # rubocop:enable RSpec/StubbedMock, RSpec/MultipleExpectations, RSpec/AnyInstance
  end

  describe 'with VCR' do
    let(:url) { CreateResultsJob::URL }

    # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
    it 'return results' do
      VCR.use_cassette('google') do
        crawler = described_class.new([Fabricate.create(:keyword)], url)
        results = crawler.results
        expect(results[0][:total_urls]).not_to be_nil
        expect(results[0][:total_advertisers]).not_to be_nil
        expect(results[0][:stats]).not_to be_nil
        expect(results[0][:keyword_id]).not_to be_nil
      end
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
  end
end
