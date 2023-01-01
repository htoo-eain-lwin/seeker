# frozen_string_literal: true

require 'rails_helper'

describe CreateResultService do
  let(:keyword) { Fabricate.create :keyword }
  let(:results) do
    {
      keyword_id: keyword.id,
      stats: "About #{rand(100_000..500_000)} results (#{rand(0.1..3).round(2)} seconds)",
      total_urls: rand(100_000..500_000),
      total_advertisers: rand(0..7),
      html_file: Rack::Test::UploadedFile.new(
        File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.html'))
      )
    }
  end

  describe 'call' do
    before(:each) { allow(KeywordToResultsService).to receive(:call).and_return(results) }

    it { expect(described_class.call(keyword)).to be(true) }

    it 'create new result' do
      described_class.call(keyword)
      keyword.reload
      expect(keyword.result.present?).to be(true)
    end
  end
end
